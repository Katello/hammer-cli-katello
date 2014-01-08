require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman/commands'

module HammerCLIKatello

  class Provider < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIForeman::ListCommand
      resource KatelloApi::Resources::Provider, "index"      
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
      resource KatelloApi::Resources::Provider, "show"      
      output ListCommand.output_definition do
        field :created_at, "Created at", Fields::Date
        field :updated_at, "Updated at", Fields::Date
      end

    end


    class CreateCommand < HammerCLIForeman::CreateCommand
      resource KatelloApi::Resources::Provider, "create"

      success_message "Provider created"
      failure_message "Could not create the provider"

      apipie_options
    end


    class DeleteCommand < HammerCLIForeman::DeleteCommand
      resource KatelloApi::Resources::Provider, "destroy"
              
      success_message "Provider deleted"
      failure_message "Could not delete the provider"
    end


    class UpdateCommand < HammerCLIForeman::UpdateCommand
      resource KatelloApi::Resources::Provider, "update"
              
      success_message "Provider updated"
      failure_message "Could not update the provider"

      apipie_options
    end
    
    class UploadManifestCommand < HammerCLIForeman::WriteCommand
      resource KatelloApi::Resources::Provider, "import_manifest"
      command_name "import_manifest"        
              
      option "--file", "MANIFEST", "Path to a file that contains the manifest", :attribute_name => :import, :required => true,
        :format => HammerCLI::Options::Normalizers::File.new
      
      #TODO: Async this.
      success_message "Manifest is being uploaded"
      failure_message "Manifest upload failed"


      apipie_options :without => [:import]
      
    end    

    autoload_subcommands

  end

end

HammerCLI::MainCommand.subcommand 'provider', "Manipulate providers", HammerCLIKatello::Provider

