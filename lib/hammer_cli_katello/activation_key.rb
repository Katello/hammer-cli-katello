module HammerCLIKatello

  class ActivationKeyCommand < HammerCLIKatello::Command
    resource :activation_keys

    class ListCommand < HammerCLIKatello::ListCommand
      action :index

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :format_consumed, _("Consumed")
      end

      def extend_data(data)
        data["format_consumed"] = _("%{consumed} of %{limit}") %
          {
            :consumed => data["usage_count"],
            :limit => data["usage_limit"] == -1 ? _("Unlimited") : data["usage_limit"]
          }
        data
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      action :show

      output do
        field :name, _("Name")
        field :id, _("ID")
        field :description, _("Description")
        from :environment do
          field :name, _("Lifecycle Environment")
        end
        from :content_view do
          field :name, _("Content View")
        end

        collection :system_groups, _("System Groups") do
          field :id, _("ID")
          field :name, _("Name")
        end
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      action :create
      success_message _("Activation key created")
      failure_message _("Could not create the activation key")

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      action :update
      success_message _("Activation key updated")
      failure_message _("Could not update the activation key")

      build_options
    end

    class SubscriptionsCommand < HammerCLIKatello::ListCommand
      resource :subscriptions, :index
      desc _("List associated subscriptions")
      command_name "subscriptions"

      output do
        field :id, _("ID")
        field :product_name, _("Name")
      end

      option '--id', 'ID', _("resource ID")

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
      resource :subscriptions, :create

      desc "Add subscription"
      command_name "add-subscription"

      option '--id', 'ID', _("resource ID")
      option '--subscription-id', 'ID', _("subscription ID")
      option '--quantity', 'QUANTITY', _("subscription quantity")

      def request_params
        {
          'activation_key_id' => option_id,
          'id' => option_subscription_id,
          'quantity' => option_quantity
        }
      end

      validate_options do
        all(:option_id, :option_subscription_id).required
      end

      success_message _("Subscription added to activation key")
      failure_message _("Could not add subscription to activation key")
    end

    class RemoveSubscriptionCommand < HammerCLIKatello::UpdateCommand
      resource :subscriptions, :destroy

      desc _("Remove subscription")
      command_name "remove-subscription"

      option '--id', 'ID', _("resource ID")
      option '--subscription-id', 'ID', _("subscription ID")

      def request_params
        {
          'id' => option_subscription_id,
          'activation_key_id' => option_id
        }
      end

      validate_options do
        all(:option_id, :option_subscription_id).required
      end
      success_message _("Subscription removed from activation key")
      failure_message _("Could not remove subscription from activation key")
    end

    class SystemGroupsCommand < HammerCLIKatello::ListCommand
      resource :system_groups, :index

      desc _("List associated system groups")
      command_name "system-groups"

      output do
        field :id, _("ID")
        field :name, _("Name")
      end

      option '--id', 'ID', _("resource ID")

      def request_params
        {
          'activation_key_id' => option_id
        }
      end

      validate_options do
        all(:option_id).required
      end
    end

    HammerCLIKatello::AssociatingCommands::SystemGroup.extend_command(self)

    autoload_subcommands
  end

end

HammerCLI::MainCommand.subcommand("activation-key", _("Manipulate activation keys."),
                                  HammerCLIKatello::ActivationKeyCommand)
