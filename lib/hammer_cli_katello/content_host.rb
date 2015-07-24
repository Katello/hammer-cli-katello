module HammerCLIKatello

  class ContentHostCommand < HammerCLI::AbstractCommand
    module IdDescriptionOverridable
      def self.included(base)
        base.option "--id", "ID",
                    _("ID of the content host")
      end
    end

    class ListCommand < HammerCLIKatello::ListCommand
      include LifecycleEnvironmentNameResolvable
      resource :systems, :index

      output do
        field :uuid, _("ID")
        field :name, _("Name")
        from :errata_counts do
          field :total, _("Installable Errata")
        end
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include LifecycleEnvironmentNameResolvable
      include IdDescriptionOverridable
      resource :systems, :show

      output do
        field :name, _("Name")
        field :uuid, _("ID")
        field :katello_agent_installed, _("Katello Agent Installed"), Fields::Boolean
        field :description, _("Description")
        field :location, _("Location")
        from :environment do
          field :name, _("Lifecycle Environment")
        end
        from :content_view do
          field :name, _("Content View")
        end
        field :entitlementStatus, _("Entitlement Status")
        field :release_ver, _("Release Version")
        field :autoheal, _("Autoheal")
        from :errata_counts do
          field :security, _("Security Errata")
          field :bugfix, _("Bugfix Errata")
          field :enhancement, _("Enhancement Errata")
        end
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      include LifecycleEnvironmentNameResolvable
      resource :systems, :create

      output InfoCommand.output_definition

      success_message _("Content host created")
      failure_message _("Could not create content host")

      def request_params
        super.tap do |params|
          params['type'] = "system"
          params['facts'] = {"uname.machine" => "unknown"}
        end
      end

      validate_options do
        if any(:option_environment_id, :option_environment_name).exist?
          any(:option_content_view_name, :option_content_view_id).required
        end
      end

      build_options :without => [:facts, :type, :installed_products]
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      include IdDescriptionOverridable
      include LifecycleEnvironmentNameResolvable
      resource :systems, :update

      success_message _("Content host updated")
      failure_message _("Could not update content host")

      def request_params
        params = super
        params.delete('facts')
        params
      end

      build_options :without => [:facts, :type, :installed_products]
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include IdDescriptionOverridable
      include LifecycleEnvironmentNameResolvable
      resource :systems, :destroy

      success_message _("Content host deleted")
      failure_message _("Could not delete content host")

      build_options
    end

    class TasksCommand < HammerCLIKatello::ListCommand
      include IdDescriptionOverridable
      resource :systems, :tasks

      command_name "tasks"

      build_options
    end

    class AvailableIncrementalUpdates < HammerCLIKatello::ListCommand
      resource :systems_bulk_actions, :available_incremental_updates
      command_name 'available-incremental-updates'

      option("--id", "ID", _("ID of a content host"))

      def extend_data(data)
        data['environments'] = data['environments'].map { |env| env['name'] }.join(',')
        data
      end

      output do
        from :content_view_version do
          from :content_view do
            field :name, _("Name")
          end
          field :version, _("Version")
        end

        field :environments, _("Environments")
      end

      def request_params
        params = super
        params.delete('exclude')
        params.delete('ids')

        params[:ids] = params[:id]
        params.delete('id')

        params
      end

      build_options :without => [:id]
    end

    autoload_subcommands

    class GetContentOverrideCommand < HammerCLIKatello::ListCommand
      resource :host_subscriptions
      action :product_content
      command_name "list"
    end

    class SetContentOverrideCommand < HammerCLIKatello::SingleResourceCommand
      resource :host_subscriptions
      action :content_override
      command_name "update"
    end

    require 'hammer_cli_katello/content_host_content_override'
    subcommand HammerCLIKatello::ContentHostContentOverrideCommand.command_name,
               HammerCLIKatello::ContentHostContentOverrideCommand.desc,
               HammerCLIKatello::ContentHostContentOverrideCommand
  end
end
