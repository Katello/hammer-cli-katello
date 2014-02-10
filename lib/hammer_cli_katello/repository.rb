module HammerCLIKatello

  class Repository < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Repository

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, "Id"
        field :label, "Label"
        field :description, "Description"
      end

      apipie_options
    end

    class SyncCommand < HammerCLIForemanTasks::AsyncCommand
      action "sync"
      command_name "synchronize"

      success_message "Repository is being synchronized in task %{id}s"
      failure_message "Could not synchronize the repository"

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "repository", "Manipulate repositories",
                                  HammerCLIKatello::Repository
