require 'hammer_cli_katello/content_export_complete'
require 'hammer_cli_katello/content_export_incremental'

module HammerCLIKatello
  class ContentExport < HammerCLIKatello::Command
    desc "Prepare content for export to a disconnected Katello"
    resource :content_exports

    class GenerateMetadataCommand < HammerCLIKatello::Command
      desc _("Writes export metadata to disk for use by the importing Katello. This command "\
        + "only needs to be used if the export was performed asynchronously "\
        + "or if the metadata was lost")

      command_name 'generate-metadata'

      include ContentExportHelper

      option "--task-id", "TASK_ID",
             _("Generate metadata based on output of the specified export task"),
             :attribute_name => :option_task_id,
             :required => false

      option "--id", "ID",
             _("Generate metadata based on specified export history"),
             :attribute_name => :option_export_id,
             :required => false

      def execute
        export_history = if option_task_id
                           export_task = reload_task(option_task_id)
                           fetch_export_history_from_task(export_task)
                         else
                           fetch_export_history(option_export_id)
                         end

        unless export_history
          raise _("No export history was found. Verify the value given for "\
            + "--task-id or --id")
        end

        generate_metadata_json(export_history)

        HammerCLI::EX_OK
      end
    end

    class GenerateListingCommand < HammerCLIKatello::Command
      desc _("Generates listing file on each directory of a syncable export. This command "\
        + "only needs to be used if the export was performed asynchronously or "\
        + "if the listing files were lost. "\
        + "Assumes the syncable export directory is accessible on disk")

      command_name 'generate-listing'

      include ContentExportHelper

      option "--task-id", "TASK_ID",
             _("Generate listing files for a syncable export task"),
             :attribute_name => :option_task_id,
             :required => false

      option "--id", "ID",
             _("Generate listing files based on specified export history"),
             :attribute_name => :option_export_id,
             :required => false

      def execute
        export_history = if option_task_id
                           export_task = reload_task(option_task_id)
                           fetch_export_history_from_task(export_task)
                         else
                           fetch_export_history(option_export_id)
                         end

        unless export_history
          raise _("No export history was found. Verify the value given for "\
            + "--task-id or --id")
        end

        make_listing_files(export_history)
        output.print_message _("Generated #{export_history['path']}")
        HammerCLI::EX_OK
      end
    end

    class ListCommand < HammerCLIKatello::ListCommand
      desc "View content view export histories"
      output do
        field :id, _('ID')
        field :destination_server, _('Destination Server')
        field :path, _('Path')
        field :type, _('Type')
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
