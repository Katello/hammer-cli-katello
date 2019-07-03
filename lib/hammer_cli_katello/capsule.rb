require 'hammer_cli_foreman/smart_proxy'

module HammerCLIKatello
  module Capsule
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
        include LifecycleEnvironmentNameMapping

        resource :capsule_content, :add_lifecycle_environment
        command_name 'add-lifecycle-environment'

        success_message _("Lifecycle environment successfully added to the capsule.")
        failure_message _("Could not add the lifecycle environment to the capsule")

        option "--organization-id", "ID", _("Organization ID"),
               :attribute_name => :option_organization_id
        option "--organization", "NAME", _("Organization name"),
               :attribute_name => :option_organization_name
        build_options

        extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
      end

      class RemoveLifecycleEnvironmentCommand < HammerCLIKatello::Command
        include LifecycleEnvironmentNameMapping

        resource :capsule_content, :remove_lifecycle_environment
        command_name 'remove-lifecycle-environment'

        success_message _("Lifecycle environment successfully removed from the capsule.")
        failure_message _("Could not remove the lifecycle environment from the capsule")

        option "--organization-id", "ID", _("Organization ID"),
               :attribute_name => :option_organization_id
        option "--organization", "NAME", _("Organization name"),
               :attribute_name => :option_organization_name
        build_options

        extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
      end

      class SyncCommand < HammerCLIKatello::SingleResourceCommand
        include HammerCLIForemanTasks::Async
        include LifecycleEnvironmentNameMapping

        resource :capsule_content, :sync
        command_name "synchronize"

        success_message _("Capsule content is being synchronized in task %{id}.")
        failure_message _("Could not synchronize capsule content")

        option "--organization-id", "ID", _("Organization ID"),
               :attribute_name => :option_organization_id
        option "--organization", "NAME", _("Organization name"),
               :attribute_name => :option_organization_name
        build_options

        extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
      end

      class SyncStatusCommand < HammerCLIKatello::InfoCommand
        resource :capsule_content, :sync_status
        command_name "synchronization-status"

        output do
          field :last_sync_time, _('Last sync'), Fields::Date
          field :_status, _('Status')
          collection :active_sync_tasks, _('Currently running sync tasks') do
            field :id, _('Task id')
            field :_progress, _('Progress')
          end
          label _('Last failure') do
            from :_last_failure do
              field :id, _('Task id')
              from :humanized do
                field :errors, _('Messages'), Fields::List, :on_new_line => true, :separator => "\n"
              end
            end
          end
        end

        private

        def extend_data(data)
          data["_status"] = sync_status(data)
          data['_last_failure'] = data["last_failed_sync_tasks"][-1]

          data["active_sync_tasks"].each do |task|
            task['_progress'] = format_progress(task['progress'])
          end
          data
        end

        def sync_status(data)
          syncable_envs = data["lifecycle_environments"].select { |env| env['syncable'] }
          if syncable_envs.empty?
            _("Capsule is synchronized")
          else
            env_names = syncable_envs.map { |env| env['name'] }.join(", ")
            _("%{count} environment(s) can be synchronized: %{names}") % {
              :count => syncable_envs.size,
              :names => env_names
            }
          end
        end

        def format_progress(progress)
          "#{(progress * 100).floor}%"
        end

        build_options
      end

      class InfoCommand < HammerCLIKatello::InfoCommand
        resource :capsule_content, :sync_status
        command_name "info"

        output do
          collection :lifecycle_environments, _("Lifecycle Environments") do
            field :name, _('Name')
            field :organization, _("Organization"), Fields::Reference
            collection :content_views, _("Content Views") do
              field nil, _("Name"), Fields::Reference
              field :composite, _('Composite'), Fields::Boolean
              field :last_published, _('Last Published'), Fields::Date
              label _('Content') do
                from :counts do
                  field :content_hosts, _('Hosts')
                  field :products, _('Products')
                  field :yum_repositories, _('Yum repos')
                  field :docker_repositories, _('Container Image repos')
                  field :packages, _('Packages')
                  field :package_groups, _('Package groups')
                  field :errata, _('Errata')
                  field :puppet_modules, _('Puppet modules')
                end
              end
            end
          end
        end

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
