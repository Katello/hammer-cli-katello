module HammerCLIKatello
  class FlatpakRemoteRepository < HammerCLIKatello::Command
    resource :flatpak_remote_repositories
    command_name 'remote-repository'
    desc _('View and manage flatpak remote repositories')

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Id")
        field :name, _("Name")
        field :label, _("Label")
      end
      build_options do |o|
        o.expand(:all).including(:flatpak_remotes, :organizations)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("Id")
        field :name, _("Name")
        field :label, _("Label")
        from :flatpak_remote do
          field :id, _("Flatpak Remote ID")
          field :name, _("Flatpak Remote Name")
          field :url, _("Flatpak Remote URL")
        end
        collection :manifests, _("Manifests"), hide_blank: true, hide_empty: true do
          field :name, _("Manifest Name")
          field :digest, _("Manifest Digest")
          field :tags, _("Manifest tags")
        end
      end
      build_options do |o|
        o.expand(:all).including(:flatpak_remotes, :organizations)
      end
    end

    class MirrorCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

      action :mirror
      command_name 'mirror'

      success_message _("Flatpak remote repository is being mirrored to product in task %<id>s.")
      failure_message _('Could not mirror the Flatpak remote repository')

      build_options
    end

    autoload_subcommands
  end
end
