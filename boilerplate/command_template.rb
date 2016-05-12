module HammerCLIKatello
  class Taco < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Taco

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Taco ID")
        field :name, _("Name")
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Taco created")
      failure_message _("Could not create the taco")

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("Taco ID")
        field :name, _("Name")
        field :crunchiness, _("Crunchiness")
        field :meat, _("Meat")
      end

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Taco updated")
      failure_message _("Could not update the taco")

      build_options :without => [:doritos_locos]
      option "--meat", "MEAT", _("meat type"), :attribute_name => :option_meat
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("Taco deleted")
      failure_message _("Could not delete the taco")

      build_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "taco", _("Manipulate tacos"), HammerCLIKatello::Taco
