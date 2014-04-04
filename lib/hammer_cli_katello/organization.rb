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

    class RepoDiscoverCommand < HammerCLIForemanTasks::AsyncCommand
      resource :organizations, :repo_discover
      identifiers :url

      desc _("Perform Repository Discovery.")
      command_name "repo-discover"

      success_message _("Repository Discovery started.")
      failure_message _("Repository Discovery failed.")

      apipie_options
    end

    class CancelRepoDiscoverCommand < HammerCLIForemanTasks::AsyncCommand
      resource :organizations, :cancel_repo_discover
      identifiers :url

      desc _("Cancel Repository Discovery.")
      command_name "cancel-repo-discover"

      success_message _("Repository Discovery cancelled.")
      failure_message _("Repository Discovery cancellation failed.")

      apipie_options
    end

    autoload_subcommands
  end

end

HammerCLI::MainCommand.subcommand! 'organization', _("Manipulate organizations"),
                                   HammerCLIKatello::Organization
