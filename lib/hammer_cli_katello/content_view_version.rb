require 'fileutils'

module HammerCLIKatello
  class ContentViewVersion < HammerCLIKatello::Command
    resource :content_view_versions
    command_name 'version'
    desc 'View and manage content view versions'

    class ListCommand < HammerCLIKatello::ListCommand
      include LifecycleEnvironmentNameMapping

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :version, _("Version")
        field :environments, _("Lifecycle Environments"), Fields::List
      end

      def extend_data(version)
        version['environments'] = version['environments'].map { |e| e["name"] }
        version
      end

      build_options do |o|
        o.expand(:all).including(:organizations)
      end

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include LifecycleEnvironmentNameMapping

      resource :content_view_versions, :show

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :version, _("Version")
        field :description, _("Description")

        from :content_view do
          field :id, _("Content View ID")
          field :name, _("Content View Name")
          field :label, _("Content View Label")
        end

        collection :environments, _("Lifecycle Environments") do
          field :id, _("ID")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :repositories, _("Repositories") do
          field :id, _("ID")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :puppet_modules, _("Puppet Modules") do
          field :id, _("ID")
          field :name, _("Name")
          field :author, _("Author")
          field :version, _("Version")
        end
      end

      build_options do |o|
        o.expand(:all).including(:environments, :content_views, :organizations)
      end

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class RepublishRepositoriesCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

      action :republish_repositories
      command_name "republish-repositories"

      success_message _("Content View Version is being republished with task %{id}.")
      failure_message _("Could not republish the Content View")
      build_options do |o|
        o.expand(:all).including(:content_views, :organizations)
      end
    end

    class PromoteCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      include LifecycleEnvironmentNameMapping

      action :promote
      command_name "promote"

      success_message _("Content view is being promoted with task %{id}.")
      failure_message _("Could not promote the content view")

      option "--force",
             :flag,
             _("force content view promotion and bypass lifecycle environment restriction")

      option "--to-lifecycle-environment", "TO_ENVIRONMENT",
             _("Name of the target environment"), :attribute_name => :option_to_environment_name
      option "--to-lifecycle-environment-id", "TO_ENVIRONMENT_ID",
             _("Id of the target environment"), :attribute_name => :option_to_environment_id
      option "--from-lifecycle-environment", "FROM_ENVIRONMENT_ID",
             _("Environment name from where to promote its version from (if version is unknown)"),
             :attribute_name => :option_from_environment_name
      option "--from-lifecycle-environment-id", "FROM_ENVIRONMENT_ID",
             _(["Id of the environment from where to promote its version ",
                "from (if version is unknown)"].join),
               :attribute_name => :option_from_environment_id
      option "--environment-ids", "ENVIRONMENT_IDS", _("Identifiers for Lifecycle Environment"),
            format: HammerCLI::Options::Normalizers::List.new,
            attribute_name: :option_environment_ids,
            deprecated: { '--environment-ids' => _('Use --lifecycle-environment-ids instead') }

      def environment_search_options
        {
          "option_id" => options["option_to_environment_id"],
          "option_name" => options["option_to_environment_name"],
          "option_organization_id" => options["option_organization_id"],
          "option_organization_name" => options["option_organization_name"],
          "option_organization_label" => options["option_organization_label"]
        }
      end

      def request_params
        params = super
        params['environment_id'] = resolver.lifecycle_environment_id(environment_search_options)
        params['force'] = option_force?
        params
      end

      build_options do |o|
        o.expand(:all).except(:environments).including(:content_views, :organizations)
        o.without(:environment_id)
      end

      extend_with(
        HammerCLIKatello::CommandExtensions::LifecycleEnvironments.new(only: :option_sources)
      )
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include HammerCLIForemanTasks::Async
      include LifecycleEnvironmentNameMapping

      action :destroy
      command_name "delete"

      success_message _("Content view is being deleted with task %{id}.")
      failure_message _("Could not delete the content view")

      build_options do |o|
        o.expand(:all).including(:environments, :content_views, :organizations)
      end

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class IncrementalUpdate < HammerCLIKatello::Command
      include HammerCLIForemanTasks::Async

      action :incremental_update
      command_name "incremental-update"

      success_message _("Incremental update is being performed with task %{id}.")
      failure_message _("An error occurred incrementally updating the content view")

      option('--lifecycle-environment-ids',
             'ENVIRONMENT_IDS',
             _("list of lifecycle environment IDs to update the content view version in"),
             :format => HammerCLI::Options::Normalizers::List.new
            )

      option('--lifecycle-environments',
             'ENVIRONMENTS',
             _("list of lifecycle environment names to update the content view version in"),
             :format => HammerCLI::Options::Normalizers::List.new,
             :attribute_name => :option_lifecycle_environment_names
            )

      option('--organization',
             'ORGANIZATION_NAME',
             _("Organization name for resolving lifecycle environment names"),
             :attribute_name => :option_organization_name
            )

      option('--organization-id',
             'ORGANIZATION_ID',
             _("Organization id for resolving lifecycle environment names")
            )

      option('--update-all-hosts',
             'UPDATE',
             _('Update all editable and applicable hosts within the specified Content View and \
               Lifecycle Environments'),
             :format => HammerCLI::Options::Normalizers::Bool.new
            )

      option('--host-ids',
             'HOST_IDS',
             _("IDs of hosts to update"),
             :format => HammerCLI::Options::Normalizers::List.new
            )

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name]

        if option(:option_lifecycle_environment_ids).exist?
          any(*organization_options).rejected
          option(:option_lifecycle_environment_names).rejected
        end

        if option(:option_lifecycle_environment_names).exist?
          any(*organization_options).required
        end
      end

      def request_params
        params = super
        params[:content_view_version_environments] = [
          {
            :content_view_version_id => option_content_view_version_id
          }
        ]

        if options.key?(HammerCLI.option_accessor_name(:lifecycle_environment_names)) ||
           options.key?(HammerCLI.option_accessor_name(:lifecycle_environment_ids))
          params[:content_view_version_environments][0][:environment_ids] =
            resolver.environment_ids(options)
        end

        add_content = {}
        params['add_content'].each do |key, value|
          add_content[key] = value if options.key?(HammerCLI.option_accessor_name(key))
        end

        params = request_params_hosts(params)
        params['add_content'] = add_content

        params.delete('id')
        params
      end

      def request_params_hosts(params)
        if params['update_hosts'] && params['update_hosts']['included'] &&
           params['update_hosts']['included'].key?('ids')
          params['update_hosts'].delete('excluded')
        else
          params.delete('update_hosts')
        end

        if option_host_ids
          params['update_hosts'] = {'included' => {'ids' => option_host_ids}}
        elsif option_update_all_hosts
          params['update_hosts'] = { 'included' => {:search => ''}}
        end

        params
      end

      build_options do |o|
        o.expand(:all).except(:environments)
        o.without(:content_view_version_environments, :ids, :update_hosts, :update_hosts_included)
      end
    end

    class LegacyExportCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      include LifecycleEnvironmentNameMapping
      desc _('Export a content view (deprecated)')

      action :export
      command_name "export-legacy"

      success_message _("Content view is being exported in task %{id}.")
      failure_message _("Could not export the content view")

      build_options do |o|
        o.expand(:all).including(:environments, :content_views, :organizations)
      end

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class ExportCommand < HammerCLIForeman::Command
      include HammerCLIKatello::LocalHelper
      include HammerCLIKatello::ApipieHelper
      include HammerCLIKatello::CVImportExportHelper

      PUBLISHED_REPOS_DIR = "/var/lib/pulp/published/yum/https/repos/".freeze

      desc _('Export a content view version')

      command_name "export"

      success_message _("Content view export is available in %{directory}.")
      failure_message _("Could not export the content view")

      option "--id", "ID", _("Content View Version numeric identifier")
      option '--export-dir', 'EXPORT_DIR', _("Directory to put content view version export into.")

      validate_options do
        option(:option_export_dir).required
        option(:option_id).required
      end

      build_options

      def execute
        cvv = show(:content_view_versions, 'id' => options['option_id'])
        cv = show(:content_views, 'id' => cvv['content_view_id'])

        composite = cv["composite"]

        export_json_options = { :cvv => cvv }

        if composite
          components = cv['components']
          export_json_options[:component_cvvs] = components.collect do |component|
            component['name']
          end
          export_json_options[:repositories] = []
        else
          repositories = fetch_cvv_repositories(cvv)
          puppet_check(cvv)
          check_repo_type(repositories)
          check_repo_download_policy(repositories)
          collect_packages(repositories)

          export_json_options[:repositories] = repositories
        end

        json = export_json(export_json_options)
        if repositories&.any? || cv['composite']
          create_tar(cv, cvv, repositories, json)
        else
          msg = <<~MSG
            Ensure the content view version '#{cvv['name']}' has at least one repository.
          MSG
          raise _(msg)
        end
        return HammerCLI::EX_OK
      end

      def create_tar(cv, cvv, repositories, json)
        export_prefix = "export-#{cv['label']}-#{cvv['major']}.#{cvv['minor']}"
        export_file = "#{export_prefix}.json"
        export_repos_tar = "#{export_prefix}-repos.tar"
        export_tar = "#{export_prefix}.tar"
        export_dir = File.expand_path(options['option_export_dir'].to_s)

        Dir.mkdir("#{export_dir}/#{export_prefix}")

        if repositories&.any?

          Dir.chdir(PUBLISHED_REPOS_DIR) do
            repo_tar = "#{export_dir}/#{export_prefix}/#{export_repos_tar}"
            repo_dirs = []

            repositories.each do |repo|
              repo_dirs.push(repo['relative_path'])
            end

            `tar cvfh #{repo_tar} #{repo_dirs.join(" ")}`
          end
        end

        Dir.chdir("#{export_dir}/#{export_prefix}") do
          File.open(export_file, 'w') do |file|
            file.write(JSON.pretty_generate(json))
          end
        end

        Dir.chdir(export_dir) do
          `tar cf #{export_tar} #{export_prefix}`
          FileUtils.rm_rf(export_prefix)
        end
      end
    end

    class ImportCommand < HammerCLIForeman::Command
      include HammerCLIForemanTasks::Async
      include HammerCLIKatello::LocalHelper
      include HammerCLIKatello::ApipieHelper
      include HammerCLIKatello::CVImportExportHelper

      attr_accessor :export_tar_dir, :export_tar_file, :export_tar_prefix

      desc _('Import a content view version')

      command_name "import"

      success_message _("Content view imported.")
      failure_message _("Could not import the content view")

      option "--organization-id", "ORGANIZATION_ID", _("Organization numeric identifier")
      option(
        '--export-tar', 'EXPORT_TAR',
        _("Location of export tar on disk")
      )

      validate_options do
        option(:option_export_tar).required
        option(:option_organization_id).required
      end

      build_options

      # rubocop:disable Metrics/AbcSize
      def execute
        unless File.exist?(options['option_export_tar'])
          raise _("Export tar #{options['option_export_tar']} does not exist.")
        end

        import_tar_params = obtain_export_params(options['option_export_tar'])
        untar_export(import_tar_params)

        export_json = read_json(import_tar_params)
        cv = content_view(export_json['name'], options['option_organization_id'])
        major = export_json['major'].to_s
        minor = export_json['minor'].to_s
        import_checks(export_json, cv, major, minor)

        if export_json['composite_components']
          composite_version_ids = export_json['composite_components'].map do |component|
            find_local_component_id(component)
          end
          update(:content_views, 'id' => cv['id'], 'component_ids' => composite_version_ids)
          publish(cv['id'], export_json['major'], export_json['minor'])
        else
          sync_repositories(export_json['repositories'], options['option_organization_id'],
                            import_tar_params)
          publish(
            cv['id'], export_json['major'],
            export_json['minor'], repos_units(export_json['repositories'])
          )
        end
        return HammerCLI::EX_OK
      end
      # rubocop:enable Metrics/AbcSize

      def sync_repositories(repositories, organization_id, options)
        export_tar_dir =  options[:dirname]
        export_tar_prefix = options[:prefix]

        repositories.each do |repo|
          library_repos = index(
            :repositories,
            'organization_id' => organization_id,
            'library' => true
          )

          library_repo = library_repos.select do |candidate_repo|
            candidate_repo['label'] == repo['label']
          end

          library_repo = library_repo.first

          if library_repo.nil?
            msg = _("Unable to sync repositories, no library repository found for %s")
            raise msg % repo['label']
          end

          synchronize(
            library_repo['id'],
            "file://#{export_tar_dir}/#{export_tar_prefix}/#{repo['relative_path']}"
          )
        end
      end

      def repos_units(repositories)
        repositories.collect do |repo|
          {
            'label' => repo['label'],
            'rpm_filenames' => repo['rpm_filenames']
          }
        end
      end

      def content_view(name, organization_id)
        index(:content_views, 'name' => name, 'organization_id' => organization_id).first
      end

      def synchronize(id, source_url)
        task_progress(call(:sync, :repositories, 'id' => id, 'source_url' => source_url))
      end

      def publish(id, major, minor, repos_units = nil)
        params = {'id' => id, 'major' => major, 'minor' => minor }
        params['repos_units'] = repos_units if repos_units
        task_progress(call(:publish, :content_views, params))
      end
    end

    autoload_subcommands
  end
end
