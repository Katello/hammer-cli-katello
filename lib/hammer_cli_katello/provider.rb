module HammerCLIKatello
  class Provider < HammerCLIKatello::Command
    resource :providers

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :provider_type, _("Type")
        field :total_products, _("Products")
        field :total_repositories, _("Repositories")
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output ListCommand.output_definition do
        field :created_at, _("Created at"), Fields::Date
        field :updated_at, _("Updated at"), Fields::Date
      end
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Provider updated")
      failure_message _("Could not update the provider")

      apipie_options
    end

    class RefreshManifestCommand < HammerCLIKatello::WriteCommand
      action "refresh_manifest"
      command_name "refresh_manifest"

      success_message _("Manifest is being refreshed")
      failure_message _("Could not refresh the manifest")

      apipie_options
    end

    class DeleteManifestCommand < HammerCLIKatello::DeleteCommand
      action "delete_manifest"
      command_name "delete_manifest"

      success_message _("Manifest deleted")
      failure_message _("Could not delete the manifest")

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand 'provider', _("Manipulate providers"),
                                  HammerCLIKatello::Provider
