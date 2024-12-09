require 'hammer_cli_katello/flatpak_remote_repository'
module HammerCLIKatello
  class FlatpakRemoteCommand < HammerCLIKatello::Command
    resource :flatpak_remotes

    class ListCommand < HammerCLIKatello::ListCommand
      include OrganizationOptions
      output do
        field :id, _('ID')
        field :name, _('Name')
        field :url, _('URL')
        field :description, _('Description')
        field :username, _('Username')
        field :registry_url, _('Registry URL')
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include OrganizationOptions
      output do
        field :id, _('ID')
        field :name, _('Name')
        field :label, _('Label')
        field :description, _('Description'), Fields::Field, :hide_blank => true
        field :url, _('Flatpak index URL')
        field :username, _('Username'), Fields::Field, :hide_blank => true
        field :registry_url, _('Registry URL')
        collection :organization, _('Organization') do
          field :id, _('Id')
          field :name, _('Name')
          field :label, _('Label')
        end
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _('Flatpak Remote created.')
      failure_message _('Could not create the Flatpak Remote.')

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      include OrganizationOptions
      success_message _('Flatpak Remote updated.')
      failure_message _('Could not update the Flatpak Remote.')

      build_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include OrganizationOptions
      success_message _('Flatpak Remote deleted.')
      failure_message _('Could not delete the Flatpak Remote.')

      build_options
    end

    class ScanCommand < HammerCLIKatello::SingleResourceCommand
      include OrganizationOptions
      include HammerCLIForemanTasks::Async

      action :scan
      command_name 'scan'

      success_message _("Flatpak remote is being scanned in task %<id>s.")
      failure_message _('Could not scan the Flatpak remote')

      build_options
    end

    autoload_subcommands

    subcommand HammerCLIKatello::FlatpakRemoteRepository.command_name,
               HammerCLIKatello::FlatpakRemoteRepository.desc,
               HammerCLIKatello::FlatpakRemoteRepository
  end
end
