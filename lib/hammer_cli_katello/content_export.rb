require 'hammer_cli_katello/content_export_complete'
require 'hammer_cli_katello/content_export_incremental'

module HammerCLIKatello
  class ContentExport < HammerCLIKatello::Command
    desc "Prepare content for export to a disconnected Katello"
    resource :content_exports

    class ListCommand < HammerCLIKatello::ListCommand
      desc "View content view export histories"
      output do
        field :id, _('ID')
        field :destination_server, _('Destination Server')
        field :path, _('Path')
        field :content_view_version, _('Content View Version')
        field :content_view_version_id, _('Content View Version ID')
        field :created_at, _('Created at')
        field :updated_at, _('Updated at'), Fields::Field, :hide_blank => true
      end

      build_options
    end

    autoload_subcommands

    subcommand HammerCLIKatello::ContentExportComplete.command_name,
               HammerCLIKatello::ContentExportComplete.desc,
               HammerCLIKatello::ContentExportComplete

    subcommand HammerCLIKatello::ContentExportIncremental.command_name,
               HammerCLIKatello::ContentExportIncremental.desc,
               HammerCLIKatello::ContentExportIncremental
  end
end
