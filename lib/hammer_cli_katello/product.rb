module HammerCLIKatello

  class Product < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Product

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Product ID")
        field :name, _("Name")

        from :provider do
          field :name, _("Provider")
        end

        from :organization do
          field :name, _("Organization")
        end

        field :repository_count, _("Repositories")
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Product created")
      failure_message _("Could not create the product")

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include HammerCLIKatello::ScopedNameCommand

      output do
        field :id, _("Product ID")
        field :name, _("Name")
        field :label, _("Label")
        field :description, _("Description")

        field :sync_plan_id, _("Sync Plan ID")

        from :gpg_key do
          field :id, _("GPG Key ID")
          field :name, _("GPG Key")
        end

        from :provider do
          field :name, _("Provider")
        end

        from :organization do
          field :name, _("Organization")
        end

        field :readonly, _("Readonly")

        from :permissions do
          field :deletable, _("Deletable")
        end
      end

    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Product updated")
      failure_message _("Could not update the product")

      apipie_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include HammerCLIKatello::ScopedNameCommand
      success_message _("Product destroyed")
      failure_message _("Could not destroy the product")

      apipie_options
    end

    class SetSyncPlanCommand < HammerCLIKatello::UpdateCommand
      identifiers :id, :sync_plan_id

      desc _("Assign sync plan to product.")
      command_name "set_sync_plan"

      success_message _("Synchronization plan assigned.")
      failure_message _("Could not assign synchronization plan.")

      resource KatelloApi::Resources::Product, "update"

      apipie_options :without => declared_identifiers.keys +
        [:name, :label, :provider_id, :description, :gpg_key_id]
      # TODO: set to --sync-plan-id
      option "--sync_plan_id", "SYNC_PLAN_ID", _("plan numeric identifier"),
             :attribute_name => :option_sync_plan_id, :required => true
    end

    class RemoveSyncPlanCommand < HammerCLIKatello::UpdateCommand
      identifiers :id, :sync_plan_id

      desc _("Delete assignment sync plan and product.")
      command_name "remove_sync_plan"

      success_message _("Synchronization plan removed.")
      failure_message _("Could not remove synchronization plan.")

      resource KatelloApi::Resources::Product, "update"

      apipie_options :without => [:name, :label, :provider_id, :description,
                                  :gpg_key_id, :sync_plan_id]
      option "--sync_plan_id", "SYNC_PLAN_ID", _("plan numeric identifier"),
             :attribute_name => :option_sync_plan_id, :required => true
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "product", _("Manipulate products."),
                                  HammerCLIKatello::Product
