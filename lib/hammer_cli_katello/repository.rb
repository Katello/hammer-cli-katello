module HammerCLIKatello

  class Repository < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Repository

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, _("Id")
        field :_enabled, _("Enabled")
        field :name, _("Name")
        field :description, _("Description")
      end

      def extend_data(data)
        data["_enabled"] = data["enabled"] ? _("yes") : _("no")
        data
      end

      apipie_options
    end

    class CreateCommand < HammerCLIForeman::CreateCommand
      identifiers :id

      success_message "Repository created"
      failure_message "Could not create the repository"

      apipie_options
    end

    class SyncCommand < HammerCLIForemanTasks::AsyncCommand
      action "sync"
      command_name "synchronize"

      success_message _("Repository is being synchronized in task %{id}")
      failure_message _("Could not synchronize the repository")

      apipie_options
    end

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      identifiers :id

      success_message "Repository updated"
      failure_message "Could not update the repository"

      apipie_options
    end

    class DeleteCommand < HammerCLIForeman::DeleteCommand
      identifiers :id

      success_message "Repository deleted"
      failure_message "Could not delete the repository"

      apipie_options
    end

    class EnableCommand < HammerCLIForeman::UpdateCommand
      command_name "enable"
      action :enable

      success_message "Repository enabled"
      failure_message "Could not enable the repository"

      apipie_options
    end

    class DisableCommand < HammerCLIForeman::UpdateCommand
      command_name "disable"
      action :disable

      success_message "Repository disabled"
      failure_message "Could not disable the repository"

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "repository", _("Manipulate repositories"),
                                  HammerCLIKatello::Repository
