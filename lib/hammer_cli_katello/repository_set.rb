module HammerCLIKatello

  class RepositorySetCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::RepositorySet, :index

      output do
        field :id, "ID"
        field :_enabled, "Enabled"
        field :name, "Name"
      end

      def extend_data(data)
        data["_enabled"] = data["katello_enabled"] ? "enabled" : "disabled"
        data
      end

      def adapter
        :csv
      end

      apipie_options
    end

    class EnableCommand < HammerCLIKatello::UpdateCommand
      command_name "enable"
      resource KatelloApi::Resources::RepositorySet, :enable
      success_message "Repository set enabled"
      failure_message "Could not enable repository set"

      apipie_options
    end

    class DisableCommand < HammerCLIKatello::UpdateCommand
      command_name "disable"
      resource KatelloApi::Resources::RepositorySet, :disable
      success_message "Repository set disabled"
      failure_message "Could not disable repository set"

      apipie_options
    end

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand("repository-set", "manipulate repository sets on the server",
                                    HammerCLIKatello::RepositorySetCommand)
end
