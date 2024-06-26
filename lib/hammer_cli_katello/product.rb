module HammerCLIKatello
  class Product < HammerCLIKatello::Command
    resource :products

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Id")
        field :name, _("Name")
        field :description, _("Description")

        from :organization do
          field :name, _("Organization")
        end

        field :repository_count, _("Repositories")
        field :sync_state, _("Sync State")
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Product created.")
      failure_message _("Could not create the product")

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("Id")
        field :name, _("Name")
        field :label, _("Label")
        field :description, _("Description")

        field :sync_state_aggregated, _("Sync State (all)")

        from :sync_status do
          field :state, _("Sync State (last)")
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

        collection :product_content, _("Content") do
          from :content do
            field :name, _("Repo Name")
            field :contentUrl, _("Url")
            field :type, _("Content Type")
          end
        end
      end

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Product updated.")
      failure_message _("Could not update the product")

      build_options
    end

    class UpdateProxyCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      desc _("Updates an HTTP Proxy for a product")
      resource :products_bulk_actions, :update_http_proxy
      command_name 'update-proxy'

      success_message _("Product proxy updated.")
      failure_message _("Could not update the product HTTP Proxy.")

      validate_options do
        option(:option_ids).required
        option(:option_http_proxy_policy).required
      end

      build_options
    end

    class VerifyChecksumCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      desc _("Verify checksum for one or more products")
      resource :products_bulk_actions, :verify_checksum_products
      command_name 'verify-checksum'

      success_message _("Verified checksum of product repositories with task %{id}.")
      failure_message _("Could not verify checksum of repositories in the product")

      validate_options do
        option(:option_ids).required
      end

      build_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("Product destroyed.")
      failure_message _("Could not destroy the product")

      build_options
    end

    class SyncCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

      action :sync
      command_name "synchronize"

      success_message _("Product repositories are being synchronized in task %{id}.")
      failure_message _("Could not synchronize the product repositories")

      build_options
    end

    class SetSyncPlanCommand < HammerCLIKatello::UpdateCommand
      desc _("Assign sync plan to product")
      command_name "set-sync-plan"

      success_message _("Synchronization plan assigned.")
      failure_message _("Could not assign synchronization plan")

      resource :products, :update

      build_options :without => [:name, :label, :provider_id, :description, :gpg_key_id]
    end

    class RemoveSyncPlanCommand < HammerCLIKatello::UpdateCommand
      desc _("Delete assignment sync plan and product")
      command_name "remove-sync-plan"

      success_message _("Synchronization plan removed.")
      failure_message _("Could not remove synchronization plan")

      resource :products, :update

      build_options do |o|
        o.expand(:all).except(:sync_plans)
        o.without(:sync_plan_id)
      end

      def request_params
        super.merge("sync_plan_id" => nil)
      end
    end

    autoload_subcommands
  end
end
