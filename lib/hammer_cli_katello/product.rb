module HammerCLIKatello

  class Product < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::Product

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "Product ID"
        field :name, "Name"

        from :provider do
          field :name, "Provider"
        end

        from :organization do
          field :name, "Organization"
        end

        field :repository_count, "Repositories"
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message "Product created"
      failure_message "Could not create the product"

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include HammerCLIKatello::ScopedNameCommand

      output do
        field :id, "Product ID"
        field :name, "Name"
        field :label, "Label"
        field :description, "Description"

        field :sync_plan_id, "Sync Plan ID"

        from :gpg_key do
          field :id, "GPG Key ID"
          field :name, "GPG Key"
        end

        from :provider do
          field :name, "Provider"
        end

        from :organization do
          field :name, "Organization"
        end

        field :readonly, "Readonly"

        from :permissions do
          field :deletable, "Deletable"
        end
      end

    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message "Product updated"
      failure_message "Could not update the product"

      apipie_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include HammerCLIKatello::ScopedNameCommand
      success_message "Product destroyed"
      failure_message "Could not destroy the product"

      apipie_options
    end

    class SetSyncPlanCommand < HammerCLIKatello::UpdateCommand
      identifiers :id, :sync_plan_id

      desc "Assign sync plan to product."
      command_name "set_sync_plan"

      success_message "Synchronization plan assigned."
      failure_message "Could not assign synchronization plan."

      resource KatelloApi::Resources::Product, "update"

      apipie_options :without => declared_identifiers.keys +
        [:name, :label, :provider_id, :description, :gpg_key_id]
      # TODO: set to --sync-plan-id
      option "--sync_plan_id", "SYNC_PLAN_ID", "plan numeric identifier",
             :attribute_name => :option_sync_plan_id, :required => true
    end

    class RemoveSyncPlanCommand < HammerCLIKatello::UpdateCommand
      identifiers :id, :sync_plan_id

      desc "Delete assignment sync plan and product."
      command_name "remove_sync_plan"

      success_message "Synchronization plan removed."
      failure_message "Could not remove synchronization plan."

      resource KatelloApi::Resources::Product, "update"

      apipie_options :without => [:name, :label, :provider_id, :description,
                                  :gpg_key_id, :sync_plan_id]
      option "--sync_plan_id", "SYNC_PLAN_ID", "plan numeric identifier",
             :attribute_name => :option_sync_plan_id, :required => true
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "product", "Manipulate products.",
                                  HammerCLIKatello::Product
