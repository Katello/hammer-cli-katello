module HammerCLIKatello

  class Product < HammerCLIKatello::Command
    resource :products

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")

        from :organization do
          field :name, _("Organization")
        end

        field :repository_count, _("Repositories")

        from :sync_status do
          field :state, _("Sync State")
        end

      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Product created")
      failure_message _("Could not create the product")

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include HammerCLIKatello::ScopedNameCommand

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :label, _("Label")
        field :description, _("Description")

        from :sync_status do
          field :state, _("Sync State")
        end

        field :sync_plan_id, _("Sync Plan ID")

        label _("GPG") do
          from :gpg_key do
            field :id, _("GPG Key ID")
            field :name, _("GPG Key")
          end
        end

        from :organization do
          field :name, _("Organization")
        end

        field :readonly, _("Readonly")

        from :permissions do
          field :deletable, _("Deletable")
        end

        collection :productContent, _("Content") do
          from :content do
            field :name, _("Repo Name")
            field :contentUrl, _("URL")
          end
        end
      end

    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Product updated")
      failure_message _("Could not update the product")

      build_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include HammerCLIKatello::ScopedNameCommand
      success_message _("Product destroyed")
      failure_message _("Could not destroy the product")

      build_options
    end

    class SetSyncPlanCommand < HammerCLIKatello::UpdateCommand
      desc _("Assign sync plan to product.")
      command_name "set-sync-plan"

      success_message _("Synchronization plan assigned.")
      failure_message _("Could not assign synchronization plan.")

      resource :products, :update

      build_options :without => [:name, :label, :provider_id, :description, :gpg_key_id]
      # TODO: set to --sync-plan-id
      option "--sync_plan_id", "SYNC_PLAN_ID", _("plan numeric identifier"),
             :attribute_name => :option_sync_plan_id, :required => true
    end

    class RemoveSyncPlanCommand < HammerCLIKatello::UpdateCommand
      desc _("Delete assignment sync plan and product.")
      command_name "remove-sync-plan"

      success_message _("Synchronization plan removed.")
      failure_message _("Could not remove synchronization plan.")

      resource :products, :update

      build_options :without => [:name, :label, :provider_id, :description,
                                  :gpg_key_id, :sync_plan_id]
      option "--sync_plan_id", "SYNC_PLAN_ID", _("plan numeric identifier"),
             :attribute_name => :option_sync_plan_id, :required => true
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "product", _("Manipulate products."),
                                  HammerCLIKatello::Product
