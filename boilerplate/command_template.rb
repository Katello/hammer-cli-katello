module HammerCLIKatello

  class Taco < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Taco

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, "Taco ID"
        field :name, "Name"
      end

      apipie_options
    end

    class CreateCommand < HammerCLIForeman::CreateCommand
      success_message "Taco created"
      failure_message "Could not create the taco"

      apipie_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      output do
        field :id, "Taco ID"
        field :name, "Name"
        field :crunchiness, "Crunchiness"
        field :meat, "Meat"
      end

      apipie_options
    end

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      success_message "Taco updated"
      failure_message "Could not update the taco"

      apipie_options :without => [:doritos_locos]
      option "--meat", "MEAT", "meat type", :attribute_name => :option_meat
    end

    class DeleteCommand < HammerCLIForeman::DeleteCommand
      success_message "Taco deleted"
      failure_message "Could not delete the taco"

      apipie_options
    end

    autoload_subcommands

  end

end

HammerCLI::MainCommand.subcommand "taco", "Manipulate tacos", HammerCLIKatello::Taco
