module HammerCLIKatello
  class ContentExport < HammerCLIKatello::Command
    desc "Prepare content for export to a disconnected Katello"
    resource :content_exports

    class VersionCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      desc _('Export a content view version')
      action :export

      command_name "version"

      success_message _("Content view version is being exported in task %{id}.")
      failure_message _("Could not export the content view version")

      build_options do |o|
        o.expand(:all).including(:content_views, :organizations)
      end

      def execute
        # rubocop:disable LineLength
        response = super
        if option_async? || response != HammerCLI::EX_OK
          response
        else
          @task = load_task(@task['id'])
          export_history_id = @task["output"]["export_history_id"]
          export_history = resource.call(:export_histories, :export_history_id => export_history_id)["results"].first if export_history_id
          if export_history
            generate_metadata_json(export_history)
            HammerCLI::EX_OK
          else
            output.print_error _("Could not fetch the export history for id = '#{export_history_id}'")
            HammerCLI::EX_CANTCREAT
          end
        end
      end

      def send_request
        @task = super
      end

      private def generate_metadata_json(export_history)
        metadata_json = export_history["metadata"]
        begin
          metadata_path = "#{export_history['path']}/metadata.json"
          File.write(metadata_path, metadata_json)
          output.print_message _("Generated #{metadata_path}")
        rescue SystemCallError
          t = Tempfile.new("metadata.json")
          t.write(metadata_json)
          t.close
          output.print_message _("Unable to access/write to #{export_history['path']}. Generated #{t.path} instead. You would need this file for importing.")
          # rubocop:enable LineLength
        end
      end
    end

    class HistoriesCommand < HammerCLIKatello::ListCommand
      desc "View content view export histories"
      command_name "histories"
      action :export_histories

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
  end
end
