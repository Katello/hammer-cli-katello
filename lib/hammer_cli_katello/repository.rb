module HammerCLIKatello

  class Repository < HammerCLIKatello::Command
    resource :repositories

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Id")
        field :label, _("Label")
        field :description, _("Description")
      end

      apipie_options
    end

    class SyncCommand < HammerCLIForemanTasks::AsyncCommand
      action :sync
      command_name "synchronize"

      success_message _("Repository is being synchronized in task %{id}s")
      failure_message _("Could not synchronize the repository")

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "repository", _("Manipulate repositories"),
                                  HammerCLIKatello::Repository
