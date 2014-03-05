module HammerCLIKatello

  class SystemGroup < HammerCLI::AbstractCommand
    class ListCommand < HammerCLIKatello::ListCommand
      resource :system_groups, :index

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :max_systems, _("Limit")
        field :description, _("Description")
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource :system_groups, :create

      success_message _("System group created")
      failure_message _("Could not create the system group")

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :system_groups, :show

      output ListCommand.output_definition do
      end
    end

    class CopyCommand < HammerCLIKatello::CreateCommand
      success_message _("System group created")
      failure_message _("Could not create the system group")
      command_name "copy"
      action :copy

      validate_options do
        all(:option_name).required unless option(:option_id).exist?
      end
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand 'systemgroup', _("Manipulate system groups"),
                                  HammerCLIKatello::SystemGroup
