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
      :content_view_version => [s("version", _("Content view version number"))]
    }

    DEFAULT_SEARCHABLES = [s_name(_("Name to search by"))]

    def for(resource)
      SEARCHABLES[resource.singular_name.to_sym] || DEFAULT_SEARCHABLES
    end

  end

  # rubocop:disable ClassLength
  class IdResolver < HammerCLIForeman::IdResolver

    def capsule_content_id(options)
      smart_proxy_id(options)
    end

    def system_id(options)
      options[HammerCLI.option_accessor_name("id")] || find_resource(:systems, options)['uuid']
    end

    def environment_id(options)
      lifecycle_environment_id(options)
    end

    def environment_ids(options)
      unless options['option_lifecycle_environment_ids'].nil?
        return options['option_lifecycle_environment_ids']
      end

      key_names = HammerCLI.option_accessor_name 'lifecycle_environment_names'
      key_organization_id = HammerCLI.option_accessor_name 'organization_id'
      options[key_organization_id] ||= organization_id(scoped_options 'organization', options)

      find_resources(:lifecycle_environments, options)
        .select { |repo| options[key_names].include? repo['name'] }.map { |repo| repo['id'] }
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
      key_content_view_id = HammerCLI.option_accessor_name("content_view_id")
      from_environment_id = HammerCLI.option_accessor_name("from_environment_id")

      return options[key_id] if options[key_id]

      begin
        options[key_environment_id] ||= lifecycle_environment_id(
          scoped_options("environment", options)
        )
      rescue HammerCLIForeman::MissingSeachOptions # rubocop:disable HandleExceptions
        # Intentionally suppressing the exception,
        # environment is not always required.
      end

      begin
        options[key_content_view_id] ||= content_view_id(
          scoped_options("content_view", options)
        )
      rescue HammerCLIForeman::MissingSeachOptions # rubocop:disable HandleExceptions
        # Intentionally suppressing the exception,
        # content_view is not always required.
      end

      results = find_resources(:content_view_versions, options)
      options[from_environment_id] ||= from_lifecycle_environment_id(options)

      if results.size > 1 && options[from_environment_id]
        results_in_from_environment = results.select do  |version|
          member_of_environment_ids = version['environments'].map { |env| env['id'].to_s }
          member_of_environment_ids.include? options[from_environment_id].to_s
        end
        results_in_from_environment
          .sort { |a, b| a['version'].to_f <=> b['version'].to_f }.last['id']
      else
        pick_result(results, @api.resource(:content_view_versions))['id']
      end
    end

    def create_repositories_search_options(options)
      name = options[HammerCLI.option_accessor_name("name")]
      product_id = options[HammerCLI.option_accessor_name("product_id")]

      search_options = {}
      search_options['name'] = name if name
      search_options['product_id'] = product_id if product_id
      search_options
    end

    def create_lifecycle_environments_search_options(options)
      name = options[HammerCLI.option_accessor_name("name")]
      organization_id = options[HammerCLI.option_accessor_name("organization_id")]

      search_options = {}
      search_options['name'] = name if name
      search_options['organization_id'] = organization_id
      search_options
    end

    def create_content_view_versions_search_options(options)
      environment_id = options[HammerCLI.option_accessor_name("environment_id")]
      content_view_id = options[HammerCLI.option_accessor_name("content_view_id")]
      version = options[HammerCLI.option_accessor_name("version")]

      search_options = {}

      search_options['content_view_id'] = content_view_id if content_view_id
      search_options['environment_id'] = environment_id if environment_id && content_view_id
      search_options['version'] = version if version
      search_options
    end

    def create_organizations_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:organizations))
    end

    def create_smart_proxies_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:smart_proxies))
    end

    def create_capsules_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:smart_proxies))
    end

    def create_hosts_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:hosts))
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

    private

    def from_lifecycle_environment_id(options)
      environment_id = HammerCLI.option_accessor_name("environment_id")
      environment_name = HammerCLI.option_accessor_name("environment_name")
      from_environment_id = HammerCLI.option_accessor_name("from_environment_id")
      from_environment_name = HammerCLI.option_accessor_name("from_environment_name")
      return nil if options[from_environment_id].nil? && options[from_environment_name].nil?
      search_options = options.dup.tap do |opts|
        opts[environment_name] = opts[from_environment_name]
        opts[environment_id] = opts[from_environment_id]
      end
      lifecycle_environment_id(scoped_options("environment", search_options))
    end
  end
end
