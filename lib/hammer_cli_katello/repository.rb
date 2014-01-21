module HammerCLIKatello

  class Repository < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Repository

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, _("Id")
        field :label, _("Label")
        field :description, _("Description")
      end

      apipie_options
    end

    class CreateCommand < HammerCLIForeman::CreateCommand
      identifiers :id, :organization_id, :product_id

      success_message "Repository created"
      failure_message "Could not create the repository"

      apipie_options
    end

    class SyncCommand < HammerCLIForemanTasks::AsyncCommand
      action "sync"
      command_name "synchronize"

      success_message _("Repository is being synchronized in task %{id}s")
      failure_message _("Could not synchronize the repository")

      apipie_options
    end

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      identifiers :id, :organization_id, :product_id

      success_message "Repository updated"
      failure_message "Could not update the repository"

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "repository", _("Manipulate repositories"),
                                  HammerCLIKatello::Repository
