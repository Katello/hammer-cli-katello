module HammerCLIKatello
  class ContentViewVersion < HammerCLIKatello::Command
    resource :content_view_versions
    command_name 'version'
    desc 'View and manage content view versions'

    class ListCommand < HammerCLIKatello::ListCommand
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
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
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
    end

    class RepublishRepositoriesCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

      action :republish_repositories
      command_name "republish-repositories"

      success_message _("Content View Version is being republished with task %{id}")
      failure_message _("Could not republish the Content View")
      build_options do |o|
        o.expand(:all).including(:content_views, :organizations)
      end
    end

    class PromoteCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

      action :promote
      command_name "promote"

      success_message _("Content view is being promoted with task %{id}")
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
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include HammerCLIForemanTasks::Async

      action :destroy
      command_name "delete"

      success_message _("Content view is being deleted with task %{id}")
      failure_message _("Could not delete the content view")

      build_options do |o|
        o.expand(:all).including(:environments, :content_views, :organizations)
      end
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

      validate_options do
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

    class ExportCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

      action :export
      command_name "export"

      success_message _("Content view is being exported in task %{id}")
      failure_message _("Could not export the content view")

      build_options do |o|
        o.expand(:all).including(:environments, :content_views, :organizations)
      end
    end

    autoload_subcommands
  end
end
