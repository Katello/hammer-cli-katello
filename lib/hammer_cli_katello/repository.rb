module HammerCLIKatello

  class Repository < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Repository

    class CreateCommand < HammerCLIForeman::CreateCommand
      identifiers :id, :organization_id, :product_id

      success_message "Repository created"
      failure_message "Could not create the repository"

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

HammerCLI::MainCommand.subcommand "repository", "Manipulate repositories",
                                  HammerCLIKatello::Repository
