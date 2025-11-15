require 'hammer_cli_katello/search_options_creators'

module HammerCLIKatello
  class Searchables < HammerCLIForeman::Searchables
    SEARCHABLES = {
      :activation_key =>        [s_name(_("Activation key name to search by"))],
      :capsule =>               [s_name(_("Capsule name to search by"))],
      :content_view =>          [s_name(_("Content view name to search by"))],
      :content_view_component => [],
      :file_unit =>             [s_name(_("File name to search by")),
                                 s("content_view_version_id", _("Content View Version ID")),
                                 s("repository_id", _("Repository ID"))],
      :module_stream =>         [s_name(_("Module stream name to search by")),
                                 s("repository_id", _("Repository ID"))],
      :gpg =>                   [s_name(_("Gpg key name to search by"))],
      :host_collection =>       [s_name(_("Host collection name to search by"))],
      :environment =>           [s_name(_("Lifecycle environment name to search by"))],
      :lifecycle_environment => [s_name(_("Lifecycle environment name to search by"))],
      :organization =>          [s_name(_("Organization name to search by")),
                                 s("title", _("Organization title")),
                                 s("label", _("Organization label to search by"),
                                   :editable => false)
                                ],
      :product =>               [s_name(_("Product name to search by"))],
      :operatingsystem =>       [s("title", _("Operating system title"), :editable => false)],
      :repository =>            [s_name(_("Repository name to search by"))],
      :repository_set =>        [s_name(_("Repository set name to search by"))],
      :subscription =>          [s_name(_("Subscription name to search by"))],
      :sync_plan =>             [s_name(_("Sync plan name to search by"))],
      :task =>                  [s_name(_("Task name to search by"))],
      :content_view_version => [s("version", _("Content view version number"))],
      :flatpak_remote => [s_name(_("Flatpak remote name to search by"))],
      :content_export => [],
      :content_export_incremental => [],
      :content_import => []
    }.freeze

    DEFAULT_SEARCHABLES = [s_name(_("Name to search by"))].freeze

    def for(resource)
      SEARCHABLES[resource.singular_name.to_sym] ||
        HammerCLIForeman::Searchables::SEARCHABLES[resource.singular_name.to_sym] ||
        DEFAULT_SEARCHABLES
    end
  end

  class IdResolver < HammerCLIForeman::IdResolver
    include HammerCLIKatello::SearchOptionsCreators

    # alias_method_chain :create_search_options, :katello_api
    # alias_method :create_search_options_without_katello_api, :create_search_options
    # alias_method :create_search_options, :create_search_options_with_katello_api

    def file_unit_id(options)
      if options['option_content_view_version_version']
        options['option_content_view_version_id'] ||=
          content_view_version_id(scoped_options('content_view_version', options))
      end
      get_id(:file_units, options)
    end

    def capsule_content_id(options)
      smart_proxy_id(options)
    end

    def environment_id(options)
      lifecycle_environment_id(options)
    end

    def lifecycle_environment_ids(options)
      environment_ids(options)
    end

    def environment_ids(options)
      unless options['option_lifecycle_environment_ids'].nil?
        return options['option_lifecycle_environment_ids']
      end

      names = options[HammerCLI.option_accessor_name('lifecycle_environment_names')] ||
              options[HammerCLI.option_accessor_name('environment_names')] ||
              options[HammerCLI.option_accessor_name('names')]
      key_organization_id = HammerCLI.option_accessor_name 'organization_id'
      options[key_organization_id] ||= organization_id(scoped_options('organization', options))

      options['option_lifecycle_environment_names'] = names
      find_resources(:lifecycle_environments, options)
        .select { |repo| names.include? repo['name'] }.map { |repo| repo['id'] }
    end

    def repository_id(options)
      key_id = HammerCLI.option_accessor_name("id")
      key_product_id = HammerCLI.option_accessor_name("product_id")
      key_product_name = HammerCLI.option_accessor_name("product_name")

      return options[key_id] if options[key_id]

      unless options[key_product_name].nil?
        options[key_product_id] ||= product_id(scoped_options("product", options))
      end

      find_resource(:repositories, options)['id']
    end

    def repository_ids(options)
      return options['option_repository_ids'] unless options['option_repository_ids'].nil?

      key_names = HammerCLI.option_accessor_name 'names'
      key_product_id = HammerCLI.option_accessor_name 'product_id'

      options[key_names] ||= []

      unless options['option_product_name'].nil?
        options[key_product_id] ||= product_id(scoped_options('product', options))
      end

      if options[key_names].any?
        find_resources(:repositories, options)
          .select { |repo| options[key_names].include? repo['name'] }.map { |repo| repo['id'] }
      end
    end

    # rubocop:disable Style/EmptyElse
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def content_view_version_id(options)
      key_id = HammerCLI.option_accessor_name("id")
      key_content_view_id = HammerCLI.option_accessor_name("content_view_id")
      from_environment_id = HammerCLI.option_accessor_name("from_environment_id")

      return options[key_id] if options[key_id]

      options[key_content_view_id] ||= search_and_rescue(:content_view_id, "content_view", options)

      if options[key_content_view_id] && options['option_environment_name'] &&
         options['option_environment_id'].nil?
        lifecycle_environment_resource_name = (HammerCLIForeman.param_to_resource('environment') ||
         HammerCLIForeman.param_to_resource('lifecycle_environment')).singular_name
        options['option_environment_id'] = lifecycle_environment_id(
          scoped_options(lifecycle_environment_resource_name, options, :single))
      end

      results = find_resources(:content_view_versions, options)

      options[from_environment_id] ||= from_lifecycle_environment_id(options)

      return pick_result(results, @api.resource(:content_view_versions))['id'] if results.size == 1

      if results.size > 1 && options[from_environment_id]
        results_in_from_environment = results.select do |version|
          member_of_environment_ids = version['environments'].map { |env| env['id'].to_s }
          member_of_environment_ids.include? options[from_environment_id].to_s
        end
        results_in_from_environment
          .sort { |a, b| a['version'].to_f <=> b['version'].to_f }.last['id']
      else
        nil
      end
    end
    # rubocop:enable Style/EmptyElse
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

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

    def search_and_rescue(search_function, resource, options)
      self.send(search_function, scoped_options(resource, options))
    rescue HammerCLIForeman::MissingSearchOptions # rubocop:disable HandleExceptions
      # Intentionally suppressing the exception,
      # These are not always required.
    end
  end
  # rubocop:enable ClassLength
end
