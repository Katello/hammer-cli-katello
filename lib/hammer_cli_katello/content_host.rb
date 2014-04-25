module HammerCLIKatello

  class ContentHostCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIKatello::ListCommand
      resource :systems, :index

      output do
        field :uuid, _("ID")
        field :name, _("Name")
      end

      build_options :without => [:environment_id]
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :systems, :show

      output do
        field :name, _("Name")
        field :id, _("ID")
        field :uuid, _("UUID")
        field :description, _("Description")
        field :location, _("Location")
        from :environment do
          field :name, _("Lifecycle Environment")
        end
        from :content_view do
          field :name, _("Content View")
        end
        field :entitlementStatus, _("Entitlement Status")
        field :releaseVer, _("Release Version")
        field :autoheal, _("Autoheal")
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource :systems, :create

      success_message _("Content host created")
      failure_message _("Could not create content host")

      def request_params
        super.tap do |params|
          params['type'] = "system"
          params['facts'] = {"uname.machine" => "unknown"}
        end
      end

      build_options :without => [:facts, :type, :installed_products]
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      resource :systems, :update

      success_message _("Content host updated")
      failure_message _("Could not update content host")

      build_options :without => [:facts, :type, :installed_products]
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      resource :systems, :destroy

      success_message _("Content host deleted")
      failure_message _("Could not delete content host")

      build_options
    end

    class TasksCommand < HammerCLIKatello::ListCommand
      resource :systems, :tasks

      command_name "tasks"

      build_options
    end

    autoload_subcommands
  end

  cmd_name = "content-host"
  cmd_desc = _("manipulate content hosts on the server")
  cmd_cls  = HammerCLIKatello::ContentHostCommand
  HammerCLI::MainCommand.subcommand(cmd_name, cmd_desc, cmd_cls)

end
