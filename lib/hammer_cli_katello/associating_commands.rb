module HammerCLIKatello
  module AssociatingCommands

    module Repository

      class AddRepositoryCommand < HammerCLIKatello::AddAssociatedCommand
        associated_resource KatelloApi::Resources::Repository
        apipie_options
      end

      class RemoveRepositoryCommand < HammerCLIKatello::RemoveAssociatedCommand
        associated_resource KatelloApi::Resources::Repository
        apipie_options
      end

    end
  end
end
