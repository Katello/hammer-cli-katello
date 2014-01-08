require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman/commands'

module HammerCLIKatello

  class Provider < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Provider

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, "ID"
        field :name, "Name"
        field :provider_type, "Type"
        field :total_products, "Products"
        field :total_repositories, "Repositories"
      end

      apipie_options
    end


    class InfoCommand < HammerCLIForeman::InfoCommand
      output ListCommand.output_definition do
        field :created_at, "Created at", Fields::Date
        field :updated_at, "Updated at", Fields::Date
      end
    end


    class CreateCommand < HammerCLIForeman::CreateCommand
      success_message "Provider created"
      failure_message "Could not create the provider"

      apipie_options
    end


    class DeleteCommand < HammerCLIForeman::DeleteCommand
      success_message "Provider deleted"
      failure_message "Could not delete the provider"
    end


    class UpdateCommand < HammerCLIForeman::UpdateCommand
      success_message "Provider updated"
      failure_message "Could not update the provider"

      apipie_options
    end


    class UploadManifestCommand < HammerCLIForeman::WriteCommand
      class FileNormalizer
        class File < HammerCLI::Options::Normalizers::AbstractNormalizer
          def format(path)
            ::File.read(::File.expand_path(path), :encoding => 'ASCII-8BIT')
          end
        end
      end

      action "import_manifest"
      command_name "import_manifest"
              
      option "--file", "MANIFEST", "Path to a file that contains the manifest", :attribute_name => :import, :required => true,
        :format => FileNormalizer.new

      success_message "Manifest is being uploaded"
      failure_message "Manifest upload failed"

      apipie_options :without => [:import]
    end


    class RefreshManifestCommand < HammerCLIForeman::WriteCommand
      action "refresh_manifest"
      command_name "refresh_manifest"

      success_message "Manifest is being refreshed"
      failure_message "Could not refresh the manifest"

      apipie_options
    end


    class DeleteManifestCommand < HammerCLIForeman::DeleteCommand
      action "delete_manifest"
      command_name "delete_manifest"

      success_message "Manifest deleted"
      failure_message "Could not delete the manifest"

      apipie_options
    end

    autoload_subcommands
  end

end

HammerCLI::MainCommand.subcommand 'provider', "Manipulate providers", HammerCLIKatello::Provider