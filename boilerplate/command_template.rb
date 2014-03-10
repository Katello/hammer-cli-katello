module HammerCLIKatello

  class Taco < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Taco

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, _("Taco ID")
        field :name, _("Name")
      end

      apipie_options
    end

    class CreateCommand < HammerCLIForeman::CreateCommand
      success_message _("Taco created")
      failure_message _("Could not create the taco")

      apipie_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      output do
        field :id, _("Taco ID")
        field :name, _("Name")
        field :crunchiness, _("Crunchiness")
        field :meat, _("Meat")
      end

      apipie_options
    end

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      success_message _("Taco updated")
      failure_message _("Could not update the taco")

      apipie_options :without => [:doritos_locos]
      option "--meat", "MEAT", _("meat type"), :attribute_name => :option_meat
    end

    class DeleteCommand < HammerCLIForeman::DeleteCommand
      success_message _("Taco deleted")
      failure_message _("Could not delete the taco")

      apipie_options
    end

    autoload_subcommands

  end

end

HammerCLI::MainCommand.subcommand "taco", _("Manipulate tacos"), HammerCLIKatello::Taco
