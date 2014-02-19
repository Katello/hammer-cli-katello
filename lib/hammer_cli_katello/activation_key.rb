module HammerCLIKatello

  class ActivationKeyCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::ActivationKey, 'index'

      output do
        field :id, "ID"
        field :name, "Name"
        field :format_consumed, "Consumed"
      end

      def extend_data(data)
        data["format_consumed"] = "%{consumed} of %{limit}" %
          {
            :consumed => data["usage_count"],
            :limit => data["usage_limit"] == -1 ? "Unlimited" : data["usage_limit"]
          }
        data
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource KatelloApi::Resources::ActivationKey, :show

      identifiers :id

      output do
        field :name, "Name"
        field :id, "ID"
        field :description, "Description"
        from :environment do
          field :name, "Lifecycle Environment"
        end
        from :content_view do
          field :name, "Content View"
        end
      end

      apipie_options
    end

    class SubscriptionsCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::Subscription, :index
      desc "List associated subscriptions"
      command_name "subscriptions"

      output do
        field :id, "ID"
        field :product_name, "Name"
      end

      option '--id', 'ID', 'resource ID'

      def request_params
        {
          'activation_key_id' => option_id
        }
      end

      validate_options do
        all(:option_id).required
      end
    end

    class AddSubscriptionCommand < HammerCLIKatello::UpdateCommand
      resource KatelloApi::Resources::Subscription, :create

      desc "Add subscription"
      command_name "add-subscription"

      option '--id', 'ID', 'resource ID'
      option '--subscription-id', 'ID', 'subscription ID'
      option '--organization-id', 'ID', 'organization ID'
      option '--quantity', 'QUANTITY', 'subscription quantity'

      def request_params
        params = {
          'id' => option_subscription_id,
          'activation_key_id' => option_id,
          'organization_id' => option_organization_id
        }
        params['quantity'] = option_quantity if option_quantity
        params
      end

      validate_options do
        all(:option_id, :option_subscription_id, :option_organization_id).required
      end
    end

    class RemoveSubscriptionCommand < HammerCLIKatello::UpdateCommand
      resource KatelloApi::Resources::Subscription, :destroy

      desc "Remove subscription"
      command_name "remove-subscription"

      option '--id', 'ID', 'resource ID'
      option '--subscription-id', 'ID', 'subscription ID'

      def request_params
        {
          'id' => option_subscription_id,
          'activation_key_id' => option_id
        }
      end

      validate_options do
        all(:option_id, :option_subscription_id).required
      end
    end

    class SystemGroupsCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::SystemGroup, :index

      desc "List associated system groups"
      command_name "system-groups"

      output do
        field :id, "ID"
        field :name, "Name"
      end

      option '--id', 'ID', 'resource ID'

      def request_params
        {
          'activation_key_id' => option_id
        }
      end

      validate_options do
        all(:option_id).required
      end
    end

    class AddSystemGroupCommand < HammerCLIKatello::UpdateCommand
      resource KatelloApi::Resources::SystemGroup, :add_activation_keys

      desc "Add system group"
      command_name "add-system-group"

      option '--id', 'ID', 'resource ID'
      option '--system-group-id', 'ID', 'system group ID'

      def request_params
        {
          'id' => option_system_group_id,
          'activation_key_ids' => [option_id]
        }
      end

      validate_options do
        all(:option_id, :option_system_group_id).required
      end
    end

    class RemoveSystemGroupCommand < HammerCLIKatello::UpdateCommand
      resource KatelloApi::Resources::SystemGroup, :remove_activation_keys

      desc "Remove system group"
      command_name "remove-system-group"

      option '--id', 'ID', 'resource ID'
      option '--system-group-id', 'ID', 'system group ID'

      def request_params
        {
          'id' => option_system_group_id,
          'activation_key_ids' => [option_id]
        }
      end

      validate_options do
        all(:option_id, :option_system_group_id).required
      end
    end

    autoload_subcommands
  end

end

HammerCLI::MainCommand.subcommand("activation-key", "Manipulate activation keys.",
                                  HammerCLIKatello::ActivationKeyCommand)
