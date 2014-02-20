module HammerCLIKatello
  class Provider < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Provider

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "ID"
        field :name, "Name"
        field :provider_type, "Type"
        field :total_products, "Products"
        field :total_repositories, "Repositories"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output ListCommand.output_definition do
        field :created_at, "Created at", Fields::Date
        field :updated_at, "Updated at", Fields::Date
      end
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message "Provider updated"
      failure_message "Could not update the provider"

      apipie_options
    end

    class RefreshManifestCommand < HammerCLIKatello::WriteCommand
      action "refresh_manifest"
      command_name "refresh_manifest"

      success_message "Manifest is being refreshed"
      failure_message "Could not refresh the manifest"

      apipie_options
    end

    class DeleteManifestCommand < HammerCLIKatello::DeleteCommand
      action "delete_manifest"
      command_name "delete_manifest"

      success_message "Manifest deleted"
      failure_message "Could not delete the manifest"

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand 'provider', "Manipulate providers",
                                  HammerCLIKatello::Provider
