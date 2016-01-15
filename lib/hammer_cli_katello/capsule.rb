require 'hammer_cli_foreman/smart_proxy'

module HammerCLIKatello
  module Capsule
    module LifecycleEnvironmentNameResolvable
      def lifecycle_environment_resolve_options(options)
        {
          HammerCLI.option_accessor_name("name") => options['option_environment_name'],
          HammerCLI.option_accessor_name("id") => options['option_environment_id'],
          HammerCLI.option_accessor_name("organization_id") => options["option_organization_id"],
          HammerCLI.option_accessor_name("organization_name") => options["option_organization_name"]
        }
      end

      def all_options
        result = super.clone
        if result['option_environment_name']
          result['option_environment_id'] =  resolver.lifecycle_environment_id(
              lifecycle_environment_resolve_options(result))
        end
        result
      end
    end

    class Content < HammerCLIKatello::Command
      command_name 'content'
      desc _('Manage the capsule content')

      resource :capsules

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
        include LifecycleEnvironmentNameResolvable
        resource :capsule_content, :add_lifecycle_environment
        command_name 'add-lifecycle-environment'

        success_message _("Lifecycle environment successfully added to the capsule")
        failure_message _("Could not add the lifecycle environment to the capsule")

        option "--organization-id", "ID", _("Organization ID"),
               :attribute_name => :option_organization_id
        option "--organization", "NAME", _("Organization name"),
               :attribute_name => :option_organization_name
        build_options
      end

      class RemoveLifecycleEnvironmentCommand < HammerCLIKatello::Command
        include LifecycleEnvironmentNameResolvable
        resource :capsule_content, :remove_lifecycle_environment
        command_name 'remove-lifecycle-environment'

        success_message _("Lifecycle environment successfully removed from the capsule")
        failure_message _("Could not remove the lifecycle environment from the capsule")

        option "--organization-id", "ID", _("Organization ID"),
               :attribute_name => :option_organization_id
        option "--organization", "NAME", _("Organization name"),
               :attribute_name => :option_organization_name
        build_options
      end

      class SyncCommand < HammerCLIForemanTasks::AsyncCommand
        include LifecycleEnvironmentNameResolvable
        resource :capsule_content, :sync
        command_name "synchronize"

        success_message _("Capsule content is being synchronized in task %{id}")
        failure_message _("Could not synchronize capsule content")

        option "--organization-id", "ID", _("Organization ID"),
               :attribute_name => :option_organization_id
        option "--organization", "NAME", _("Organization name"),
               :attribute_name => :option_organization_name
        build_options
      end

      class CancelSyncCommand < HammerCLIKatello::Command
        resource :capsule_content, :cancel_sync
        command_name "cancel-synchronization"

        def print_data(message)
          print_message message
        end

        build_options
      end

      autoload_subcommands
    end

    HammerCLIForeman::SmartProxy.subcommand(
      HammerCLIKatello::Capsule::Content.command_name,
      HammerCLIKatello::Capsule::Content.desc,
      HammerCLIKatello::Capsule::Content
    )
  end
end
