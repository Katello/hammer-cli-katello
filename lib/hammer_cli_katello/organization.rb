module HammerCLIKatello

  class Organization < HammerCLIForeman::Organization

    class ListCommand < HammerCLIForeman::Organization::ListCommand
      resource KatelloApi::Resources::Organization, "index"

      output do
        field :label, "Label"
        field :description, "Description"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIForeman::Organization::InfoCommand
      resource KatelloApi::Resources::Organization, "show"

      output do
        field :label, "Label"
        field :description, "Description"
      end

      apipie_options
    end

    class UpdateCommand < HammerCLIForeman::Organization::UpdateCommand
      resource KatelloApi::Resources::Organization, "update"

      success_message "Organization updated"
      failure_message "Could not update the organization"

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource KatelloApi::Resources::Organization, "create"

      success_message "Organization created"
      failure_message "Could not create the organization"

      apipie_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      resource KatelloApi::Resources::Organization, "destroy"

      success_message "Organization deleted"
      failure_message "Could not delete the organization"

      apipie_options
    end

    autoload_subcommands
  end

end

HammerCLI::MainCommand.subcommand! 'organization', "Manipulate organizations",
                                   HammerCLIKatello::Organization
