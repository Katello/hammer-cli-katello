module HammerCLIKatello
  class Capsule < HammerCLIForeman::Command
    resource :capsules

    class ListCommand < HammerCLIKatello::ListCommand
      action :index

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :url, _("URL")
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand

      action :show

      output ListCommand.output_definition do
        field :_features, _("Features"),   Fields::List
        field :created_at, _("Created at"), Fields::Date
        field :updated_at, _("Updated at"), Fields::Date
      end

      def extend_data(proxy)
        proxy['_features'] = proxy['features'].map { |f| f['name'] }
        proxy
      end

      build_options
    end

    class Content < HammerCLI::AbstractCommand
      command_name 'content'
      desc _('Manage the capsule content')

      class ListLifecycleEnvironmentsCommand < HammerCLIKatello::ListCommand
        resource :capsule_content, :lifecycle_environments
        command_name 'lifecycle-environments'

        output do
          field :id, _("ID")
          field :name, _("Name")
          from :organization do
            field :name, _("Organization")
          end

        end

        build_options
      end

      class ListAvailableLifecycleEnvironmentsCommand < HammerCLIKatello::ListCommand
        resource :capsule_content, :available_lifecycle_environments
        command_name 'available-lifecycle-environments'

        output do
          field :id, _("ID")
          field :name, _("Name")
          from :organization do
            field :name, _("Organization")
          end

        end

        build_options
      end

      class AddLifecycleEnvironmentCommand < HammerCLIKatello::Command
        resource :capsule_content, :add_lifecycle_environment
        command_name 'add-lifecycle-environment'

        success_message _("Lifecycle environment successfully added to the capsule")
        failure_message _("Could not add the lifecycle environment to the capsule")

        build_options
      end

      class RemoveLifecycleEnvironmentCommand < HammerCLIKatello::Command
        resource :capsule_content, :remove_lifecycle_environment
        command_name 'remove-lifecycle-environment'

        success_message _("Lifecycle environment successfully removed from the capsule")
        failure_message _("Could not remove the lifecycle environment from the capsule")

        build_options
      end

      class SyncCommand < HammerCLIForemanTasks::AsyncCommand
        resource :capsule_content, :sync
        command_name "synchronize"

        success_message _("Capsule content is being synchronized in task %{id}")
        failure_message _("Could not synchronize capsule content")

        build_options
      end

      autoload_subcommands
    end

    autoload_subcommands
  end

end
