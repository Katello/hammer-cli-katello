module HammerCLIKatello

  class Organization < HammerCLIForeman::Organization

    class ListCommand < HammerCLIForeman::Organization::ListCommand
      resource :organizations, :index

      output do
        field :label, _("Label")
        field :description, _("Description")
      end

      apipie_options
    end

    class InfoCommand < HammerCLIForeman::Organization::InfoCommand
      resource :organizations, :show

      output do
        field :label, _("Label")
        field :description, _("Description")
      end

      apipie_options
    end

    class UpdateCommand < HammerCLIForeman::Organization::UpdateCommand
      resource :organizations, :update

      success_message _("Organization updated")
      failure_message _("Could not update the organization")

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource :organizations, :create

      success_message _("Organization created")
      failure_message _("Could not create the organization")

      apipie_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      resource :organizations, :destroy

      success_message _("Organization deleted")
      failure_message _("Could not delete the organization")

      apipie_options
    end

    autoload_subcommands
  end

end

HammerCLI::MainCommand.subcommand! 'organization', _("Manipulate organizations"),
                                   HammerCLIKatello::Organization
