module HammerCLIKatello
  class ContentExportComplete < HammerCLIKatello::Command
    desc "Prepare content for a full export to a disconnected Katello"
    resource :content_exports
    command_name 'complete'

    class VersionCommand < HammerCLIKatello::SingleResourceCommand
      desc _('Performs a full export a content view version')
      command_name "version"

      include HammerCLIForemanTasks::Async
      include ContentExportHelper
    end

    class LibraryCommand < HammerCLIKatello::SingleResourceCommand
      desc _("Performs a full export of the organization's library environment")
      command_name "library"

      include HammerCLIForemanTasks::Async
      include ContentExportHelper
    end

    class RepositoryCommand < HammerCLIKatello::SingleResourceCommand
      desc _("Performs a full export of a repository")
      command_name "repository"

      include HammerCLIForemanTasks::Async
      include ContentExportHelper
    end

    autoload_subcommands
  end
end
