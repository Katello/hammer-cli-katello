module HammerCLIKatello
  class ContentImport < HammerCLIKatello::Command
    desc "Import content from a content archive"
    resource :content_imports

    module ContentImportCommon
      def self.included(base)
        base.option "--metadata-file",
                "METADATA_FILE", _("Location of the metadata.json file. "\
                                   "This is not required if the metadata.json file"\
                                   " is already in the archive directory."),
                 :attribute_name => :option_metadata_file,
                 :required => false

        base.build_options do |o|
          o.expand(:all).including(:content_views, :organizations).except(:metadata)
        end

        base.validate_options do
          option(:option_path).required

          metadata_file = option(:option_metadata_file).value ||
                          File.join(option(:option_path).value, "metadata.json")
          unless File.exist?(metadata_file)
            msg = _("Unable to find '#{metadata_file}'. "\
                     "If the metadata.json file is at a different location "\
                     "provide it to the --metadata-file option ")
            raise HammerCLI::Options::Validators::ValidationError, msg
          end
        end
        base.success_message _("Archive is being imported in task %{id}.")
        base.failure_message _("Could not import the archive.")
      end

      def request_params
        super.tap do |opts|
          metadata_file = option_metadata_file || File.join(option_path, "metadata.json")
          opts["metadata"] = JSON.parse(File.read(metadata_file))
        end
      end
    end

    class VersionCommand < HammerCLIKatello::SingleResourceCommand
      desc _('Imports a content archive to a content view version')
      action :version
      command_name "version"

      include HammerCLIForemanTasks::Async
      include ContentImportCommon
    end

    class LibraryCommand < HammerCLIKatello::SingleResourceCommand
      desc _("Imports a content archive to an organization's library lifecycle environment")
      action :library
      command_name "library"

      include HammerCLIForemanTasks::Async
      include ContentImportCommon
    end

    autoload_subcommands
  end
end
