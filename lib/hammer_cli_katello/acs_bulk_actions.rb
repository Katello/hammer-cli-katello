module HammerCLIKatello
  class AcsBulkActionsCommand < HammerCLIKatello::Command
    desc 'Modify alternate content sources in bulk'
    resource :alternate_content_sources_bulk_actions

    class RefreshAllCommand < HammerCLIKatello::SingleResourceCommand
      action :refresh_all_alternate_content_sources
      command_name 'refresh-all'
      desc _("Refresh all alternate content sources")
      success_message _("Successfully refreshed all alternate content sources")
      failure_message _("Could not refresh all alternate content sources")

      build_options
    end

    class RefreshCommand < HammerCLIKatello::SingleResourceCommand
      action :refresh_alternate_content_sources
      command_name 'refresh'
      desc _("Refresh alternate content sources")
      success_message _("Successfully refreshed specified alternate content sources")
      failure_message _("Could not refresh the specified alternate content sources")

      build_options
    end

    class DestroyCommand < HammerCLIKatello::SingleResourceCommand
      action :destroy_alternate_content_sources
      command_name 'destroy'
      desc _("Destroy alternate content sources")
      success_message _("Sucessfully destroyed specified alternate content sources")
      failure_message _("Could not destroy the specified alternate content sources")

      build_options
    end

    autoload_subcommands
  end
end
