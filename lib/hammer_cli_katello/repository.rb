module HammerCLIKatello

  class Repository < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Repository

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      identifiers :id

      success_message "Repository updated"
      failure_message "Could not update the repository"

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "repository", "Manipulate repositories", HammerCLIKatello::Repository
