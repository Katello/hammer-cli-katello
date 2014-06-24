module HammerCLIKatello

  class Searchables < HammerCLIForeman::Searchables

    SEARCHABLES = {
      :activation_key =>        [s_name(_("Activation key name to search by"))],
      :capsule =>               [s_name(_("Capsule name to search by"))],
      :content_host =>          [s_name(_("Content host name to search by"))],
      :content_view =>          [s_name(_("Content view name to search by"))],
      :gpg =>                   [s_name(_("Gpg key name to search by"))],
      :host_collection =>       [s_name(_("Host collection name to search by"))],
      :lifecycle_environment => [s_name(_("Lifecycle environment name to search by"))],
      :organization =>          [s_name(_("Organization name to search by")),
                                 s("label", _("Organization label to search by"),
                                   :editable => false)
                                ],
      :product =>               [s_name(_("Product name to search by"))],
      :repository =>            [s_name(_("Repository name to search by"))],
      :repository_set =>        [s_name(_("Repository set name to search by"))],
      :subscription =>          [s_name(_("Subscription name to search by"))],
      :sync_plan =>             [s_name(_("Sync plan name to search by"))],
      :task =>                  [s_name(_("Task name to search by"))],
      :user =>                  [s_name(_("User name to search by"))]
    }

    DEFAULT_SEARCHABLES = [s_name(_("Name to search by"))]

    def for(resource)
      SEARCHABLES[resource.singular_name.to_sym] || DEFAULT_SEARCHABLES
    end

  end

  class IdResolver < HammerCLIForeman::IdResolver

    def system_id(options)
      options[HammerCLI.option_accessor_name("id")] || find_resource(:systems, options)['uuid']
    end

    def repository_id(options)
      key_id = HammerCLI.option_accessor_name("id")
      key_product_id = HammerCLI.option_accessor_name("product_id")

      return options[key_id] if options[key_id]

      options[key_product_id] ||= product_id(scoped_options("product", options))
      find_resource(:repositories, options)['id']
    end

    def create_repositories_search_options(options)
      search_options = {}
      search_options['name'] = options[HammerCLI.option_accessor_name("name")]
      search_options['product_id'] = options[HammerCLI.option_accessor_name("product_id")]
      search_options
    end

    def create_organizations_search_options(options)
      # wow, such hack, very meta, amaze
      self.class.superclass.instance_method(:create_search_options).bind(self)
        .call(options, api.resource(:organizations))
    end

    def create_search_options(options, resource)
      searchables(resource).each do |s|
        value = options[HammerCLI.option_accessor_name(s.name.to_s)]
        if value
          return {"#{s.name}" => "#{value}"}
        end
      end
      {}
    end

  end
end
