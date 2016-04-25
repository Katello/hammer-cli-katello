module HammerCLIKatello
  module SearchOptionsCreators

    def create_repositories_search_options(options)
      name = options[HammerCLI.option_accessor_name("name")]
      names = options[HammerCLI.option_accessor_name("names")]
      product_id = options[HammerCLI.option_accessor_name("product_id")]

      search_options = {}
      search_options['name'] = name if name
      search_options['names'] = names if names
      search_options['product_id'] = product_id if product_id
      search_options
    end

    def create_lifecycle_environments_search_options(options)
      name = options[HammerCLI.option_accessor_name("name")]
      organization_id = options[HammerCLI.option_accessor_name("organization_id")]

      search_options = {}
      search_options['name'] = name if name
      if options['option_lifecycle_environment_names'] || name
        search_options['organization_id'] = organization_id
      end
      search_options
    end

    def create_content_view_versions_search_options(options)
      environment_id = options[HammerCLI.option_accessor_name("environment_id")]
      content_view_id = options[HammerCLI.option_accessor_name("content_view_id")]
      version = options[HammerCLI.option_accessor_name("version")]
      names = options[HammerCLI.option_accessor_name("names")]

      search_options = {}

      search_options['content_view_id'] = content_view_id if content_view_id
      search_options['environment_id'] = environment_id if environment_id && content_view_id
      search_options['version'] = version if version
      search_options['names'] = names if names
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
        values = options[HammerCLI.option_accessor_name(s.plural_name.to_s)]
        if value
          search_options.update("#{s.name}" => "#{value}")
        elsif values
          search_options.update("#{s.plural_name}" => "#{values}")
        end
      end
      search_options
    end

  end # module SearchOptionsCreators

end # module HammerCLIKatello
