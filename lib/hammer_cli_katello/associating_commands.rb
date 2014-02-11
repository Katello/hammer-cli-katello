module HammerCLIKatello
  module AssociatingCommands

    module Repository

      class AddRepositoryCommand < HammerCLIKatello::AddAssociatedCommand
        command_name 'add-repository'
        associated_resource KatelloApi::Resources::Repository
        apipie_options
      end

      class RemoveRepositoryCommand < HammerCLIKatello::RemoveAssociatedCommand
        command_name 'remove-repository'
        associated_resource KatelloApi::Resources::Repository
        apipie_options
      end

    end

  end
end
