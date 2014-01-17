module HammerCLIKatello

  class SystemGroup < HammerCLI::AbstractCommand
    class ListCommand < HammerCLIForeman::ListCommand
      resource KatelloApi::Resources::SystemGroup, "index"

      output do
        field :id, "ID"
        field :name, "Name"
        field :max_systems, "Limit"
        field :description, "Description"
      end

      apipie_options
    end

    class CreateCommand < HammerCLIForeman::CreateCommand
      success_message "System group created"
      failure_message "Could not create the system group"
      resource KatelloApi::Resources::SystemGroup, "create"

      apipie_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      resource KatelloApi::Resources::SystemGroup, "show"

      output ListCommand.output_definition do
      end
    end

    class CopyCommand < HammerCLIForeman::CreateCommand
      success_message "System group created"
      failure_message "Could not create the system group"
      command_name "copy"
      action "copy"

      validate_options do
        unless option(:id).exist?
          all(:name).required
        end
      end
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand 'systemgroup', "Manipulate system groups", HammerCLIKatello::SystemGroup
