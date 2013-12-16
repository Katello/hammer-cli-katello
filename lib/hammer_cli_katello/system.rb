require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman/commands'

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

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand("system", "manipulate systems on the server", HammerCLIKatello::SystemCommand)
end
