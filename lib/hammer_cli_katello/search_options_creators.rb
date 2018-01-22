require 'hammer_cli_katello/foreman_search_options_creators'

module HammerCLIKatello
  module SearchOptionsCreators
    include HammerCLIKatello::ForemanSearchOptionsCreators

    def create_file_units_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:file_units), mode)
        .merge(create_search_options(options, api.resource(:file_units), mode))
    end

    def create_content_view_filter_rules_search_options(options, mode = nil)
      create_search_options_without_katello_api(
        options, api.resource(:content_view_filter_rules), mode)
    end

    def create_repositories_search_options(options, _mode = nil)
      name = options[HammerCLI.option_accessor_name("name")]
      names = options[HammerCLI.option_accessor_name("names")]
      product_id = options[HammerCLI.option_accessor_name("product_id")]

      search_options = {}
      search_options['name'] = name if name
      search_options['names'] = names if names
      search_options['product_id'] = product_id if product_id
      search_options
    end

    def create_content_views_search_options(options, _mode = nil)
      name = options[HammerCLI.option_accessor_name('name')]
      organization_id = options[HammerCLI.option_accessor_name("organization_id")] ||
                        organization_id(scoped_options('organization', options, :single))

      search_options = {}
      search_options['name'] = name if name
      if options['option_content_view_name'] || name
        search_options['organization_id'] = organization_id
      end
      search_options
    end

    def create_lifecycle_environments_search_options(options, mode = nil)
      search_options = {}
      if mode != :multi
        name = options[HammerCLI.option_accessor_name("name")]
        search_options['name'] = name if name
      end
      organization_id = organization_id(scoped_options('organization', options, :single))

      if options['option_lifecycle_environment_names'] || name
        search_options['organization_id'] = organization_id
      end
      search_options
    end

    def create_content_view_versions_search_options(options, _mode = nil)
      environment_id = options[HammerCLI.option_accessor_name("environment_id")]
      content_view_id = options[HammerCLI.option_accessor_name("content_view_id")]
      version = options[HammerCLI.option_accessor_name("version")]

      search_options = {}

      search_options['content_view_id'] = content_view_id if content_view_id
      search_options['environment_id'] = environment_id if environment_id && content_view_id
      search_options['version'] = version if version
      search_options
    end

    def create_host_collections_search_options(options, mode = nil)
      options[HammerCLI.option_accessor_name("organization_id")] ||= organization_id(
        scoped_options("organization", options, :single)
      )
      search_options = create_search_options_with_katello_api(
        options, api.resource(:host_collections), mode
      ) || {}
      search_options['organization_id'] ||= options['option_organization_id']
      search_options
    end

    def create_search_options_with_katello_api(options, resource, _mode = nil)
      search_options = {}
      searchables(resource).each do |s|
        value = options[HammerCLI.option_accessor_name(s.name.to_s)]
        if value
          search_options.update(s.name.to_s => value.to_s)
        end
      end
      search_options
    end
  end # module SearchOptionsCreators
end # module HammerCLIKatello
