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

    module SystemGroup
      extend HammerCLIForeman::AssociatingCommands::CommandExtension

      class AddSystemGroupCommand < HammerCLIKatello::AddAssociatedCommand
        command_name 'add-system-group'
        associated_resource :system_groups

        success_message _("The system group has been associated")
        failure_message _("Could not add system group")
      end

      class RemoveSystemGroupCommand < HammerCLIKatello::RemoveAssociatedCommand
        command_name 'remove-repository'
        associated_resource :system_groups

        success_message _("The system group has been removed")
        failure_message _("Could not remove system group")
      end

    end
  end
end
