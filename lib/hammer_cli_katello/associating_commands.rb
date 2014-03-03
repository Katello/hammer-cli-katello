module HammerCLIKatello
  module AssociatingCommands

    module Repository

      class AddRepositoryCommand < HammerCLIKatello::AddAssociatedCommand
        command_name 'add-repository'
        associated_resource KatelloApi::Resources::Repository
        apipie_options

        success_message "The repository has been associated"
        failure_message "Could not add repository"
      end

      class RemoveRepositoryCommand < HammerCLIKatello::RemoveAssociatedCommand
        command_name 'remove-repository'
        associated_resource KatelloApi::Resources::Repository
        apipie_options

        success_message "The repository has been removed"
        failure_message "Could not remove repository"
      end

    end
  end
end
