module HammerCLIKatello
  class ContentExportIncremental < HammerCLIKatello::Command
    desc "Prepare content for an incremental export to a disconnected Katello"
    resource :content_export_incrementals
    command_name 'incremental'

    class VersionCommand < HammerCLIKatello::SingleResourceCommand
      desc _('Performs an incremental export of a content view version')
      command_name "version"

      include HammerCLIForemanTasks::Async
      include ContentExportHelper
    end

    class LibraryCommand < HammerCLIKatello::SingleResourceCommand
      desc _("Performs an incremental export of the organization's library environment")
      command_name "library"

      include HammerCLIForemanTasks::Async
      include ContentExportHelper
    end

    class RepositoryCommand < HammerCLIKatello::SingleResourceCommand
      desc _("Performs an incremental export of a repository")
      command_name "repository"

      include HammerCLIForemanTasks::Async
      include ContentExportHelper
    end

    autoload_subcommands
  end
end
