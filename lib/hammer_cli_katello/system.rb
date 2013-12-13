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

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand("system", "systems on the katello server", HammerCLIKatello::SystemCommand)
end
