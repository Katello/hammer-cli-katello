module HammerCLIKatello

  class SystemCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIForeman::ListCommand
      resource KatelloApi::Resources::System, :index

      output do
          field :uuid, "ID"
          field :name, "Name"
      end

      apipie_options :without => [:environment_id]
    end

   class InfoCommand < HammerCLIForeman::InfoCommand
     resource KatelloApi::Resources::System, :show

     identifiers :id

     output do
       field :name, "Name"
       field :id, "ID"
       field :uuid, "UUID"
       field :description, "Description"
       field :location, "Location"
       from :environment do
         field :name, "Lifecycle Environment"
       end
       from :content_view do
         field :name, "Content View"
       end
       field :entitlementStatus, "Entitlement Status"
       field :releaseVer, "Release Version"
       field :autoheal, "Autoheal"
     end

     apipie_options
   end

   class CreateCommand < HammerCLIForeman::CreateCommand
     success_message "System created"
     failure_message "Could not create system"
     resource KatelloApi::Resources::System, :create

     def request_params
       super.tap do |params|
         params['type'] = "system"
         params['facts'] = {"uname.machine" => "unknown"} # facts can't be blank, bro
       end
     end

     apipie_options :without => [:facts, :type, :installed_products]
   end

   class UpdateCommand < HammerCLIForeman::UpdateCommand
     success_message "System updated"
     failure_message "Could not update system"
     resource KatelloApi::Resources::System, :update

     identifiers :id

     apipie_options :without => [:facts, :type, :installed_products]
   end

   class DeleteCommand < HammerCLIForeman::DeleteCommand
     success_message "System deleted"
     failure_message "Could not delete system"
     resource KatelloApi::Resources::System, :destroy

     identifiers :id

     apipie_options
   end

   class TasksCommand < HammerCLIForeman::ListCommand
     resource KatelloApi::Resources::System, :tasks

     command_name "tasks"

     identifiers :id

     apipie_options
   end

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand("system", "manipulate systems on the server", HammerCLIKatello::SystemCommand)
end
