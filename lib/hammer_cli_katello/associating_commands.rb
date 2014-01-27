module HammerCLIKatello
  module AssociatingCommands

    module Repository

      class AddRepositoryCommand < HammerCLIForeman::AddAssociatedCommand
        associated_resource KatelloApi::Resources::Repository
        apipie_options
      end

      class RemoveRepositoryCommand < HammerCLIForeman::RemoveAssociatedCommand
        associated_resource KatelloApi::Resources::Repository
        apipie_options
      end

    end
  end
end
