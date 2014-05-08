module HammerCLIKatello
  module AssociatingCommands

    module Repository
      extend HammerCLIForeman::AssociatingCommands::CommandExtension

      class AddRepositoryCommand < HammerCLIKatello::AddAssociatedCommand
        command_name 'add-repository'
        associated_resource :repositories

        success_message _("The repository has been associated")
        failure_message _("Could not add repository")
      end

      class RemoveRepositoryCommand < HammerCLIKatello::RemoveAssociatedCommand
        command_name 'remove-repository'
        associated_resource :repositories

        success_message _("The repository has been removed")
        failure_message _("Could not remove repository")
      end

    end

    module HostCollection
      extend HammerCLIForeman::AssociatingCommands::CommandExtension

      class AddHostCollectionCommand < HammerCLIKatello::AddAssociatedCommand
        command_name 'add-host-collection'
        associated_resource :host_collections

        success_message _("The host collection has been associated")
        failure_message _("Could not add host collection")
      end

      class RemoveHostCollectionCommand < HammerCLIKatello::RemoveAssociatedCommand
        command_name 'remove-repository'
        associated_resource :host_collections

        success_message _("The host collection has been removed")
        failure_message _("Could not remove host collection")
      end

    end
  end
end
