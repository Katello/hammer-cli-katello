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
      :user =>                  [s_name(_("User name to search by"))],
      :content_view_puppet_module => [
        s_name(_("Puppet module name to search by")),
        s("author", _("Puppet module's author to search by")),
        s("uuid", _("Puppet module's UUID to search by"))
      ],
      :content_view =>         [s_name(_("Content view name"))],
      :content_view_version => [s("version", _("Content view version number"))]
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

    def environment_id(options)
      lifecycle_environment_id(options)
    end

    def repository_id(options)
      key_id = HammerCLI.option_accessor_name("id")
      key_product_id = HammerCLI.option_accessor_name("product_id")

      return options[key_id] if options[key_id]

      options[key_product_id] ||= product_id(scoped_options("product", options))
      find_resource(:repositories, options)['id']
    end

    def content_view_version_id(options)
      key_id = HammerCLI.option_accessor_name("id")
      key_environment_id = HammerCLI.option_accessor_name("environment_id")

      return options[key_id] if options[key_id]

      begin
        options[key_environment_id] ||= lifecycle_environment_id(
          scoped_options("environment", options)
        )
      rescue HammerCLIForeman::MissingSeachOptions # rubocop:disable HandleExceptions
        # Intentionally suppressing the exception,
        # environment is not always required.
      end
      find_resource(:content_view_versions, options)['id']
    end

    def create_repositories_search_options(options)
      name = options[HammerCLI.option_accessor_name("name")]
      product_id = options[HammerCLI.option_accessor_name("product_id")]

      search_options = {}
      search_options['name'] = name if name
      search_options['product_id'] = product_id if product_id
      search_options
    end

    def create_content_view_versions_search_options(options)
      environment_id = options[HammerCLI.option_accessor_name("environment_id")]
      version = options[HammerCLI.option_accessor_name("version")]

      search_options = {}
      search_options['environment_id'] = environment_id if environment_id
      search_options['version'] = version if version
      search_options
    end

    def create_organizations_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:organizations))
    end

    def create_search_options_with_katello_api(options, resource)
      search_options = {}
      searchables(resource).each do |s|
        value = options[HammerCLI.option_accessor_name(s.name.to_s)]
        if value
          search_options.update("#{s.name}" => "#{value}")
        end
      end
      search_options
    end
    # alias_method_chain :create_search_options, :katello_api
    alias_method :create_search_options_without_katello_api, :create_search_options
    alias_method :create_search_options, :create_search_options_with_katello_api

  end
end
