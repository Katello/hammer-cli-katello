module HammerCLIKatello

  class ActivationKeyCommand < HammerCLIKatello::Command
    resource :activation_keys
    class Common
      INTEGER_FORMAT = /^-?\d+/
    end

    class ListCommand < HammerCLIKatello::ListCommand
      include LifecycleEnvironmentNameResolvable
      action :index

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :format_consumed, _("Consumed")
        from :environment do
          field :name, _("Lifecycle Environment")
        end
        from :content_view do
          field :name, _("Content View")
        end
      end

      def extend_data(data)
        data["format_consumed"] = _("%{consumed} of %{limit}") %
          {
            :consumed => data["usage_count"],
            :limit => data["unlimited_content_hosts"] ? _("Unlimited") : data["max_content_hosts"]
          }
        data
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include LifecycleEnvironmentNameResolvable
      action :show

      def request_params
        params = super
        if options.keys.any? { |o| o.match(/\Aoption_organization.*/) }
          params['organization_id'] = resolver.organization_id(
                            resolver.scoped_options('organization', all_options))
        end
        params
      end

      output do
        field :name, _("Name")
        field :id, _("ID")
        field :description, _("Description")
        field :format_limit, _("Content Host Limit")
        from :environment do
          field :name, _("Lifecycle Environment")
        end
        from :content_view do
          field :name, _("Content View")
        end

        collection :host_collections, _("Host Collections") do
          field :id, _("ID")
          field :name, _("Name")
        end
      end

      def extend_data(data)
        data["format_limit"] =
          data["unlimited_content_hosts"] ? _("Unlimited") : data["max_content_hosts"]
        data
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      include LifecycleEnvironmentNameResolvable
      action :create
      success_message _("Activation key created")
      failure_message _("Could not create the activation key")

      def request_params
        params = super
        if params.key?('max_content_hosts') && !params['max_content_hosts'].match(Common::INTEGER_FORMAT)
          fail ::HammerCLI::Validator::ValidationError, 'Content host limit must be an integer'
        end
        params
      end

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      include LifecycleEnvironmentNameResolvable
      action :update
      success_message _("Activation key updated")
      failure_message _("Could not update the activation key")

      build_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include LifecycleEnvironmentNameResolvable
      action :destroy
      success_message _("Activation key deleted")
      failure_message _("Could not delete the activation key")

      build_options
    end

    class SubscriptionsCommand < HammerCLIKatello::ListCommand
      resource :subscriptions, :index
      desc _("List associated subscriptions")
      command_name "subscriptions"

      output do
        field :id, _("ID")
        field :product_name, _("Name")
        field :format_consumed, _("Attached")
        field :amount, _("Quantity")
        field :start_date, _("Start Date"), Fields::Date
        field :end_date, _("End Date"), Fields::Date
        field :support_level, _("Support")
        field :contract_number, _("Contract")
        field :account_number, _("Account")
      end

      def extend_data(data)
        data["format_consumed"] = _("%{consumed} of %{limit}") %
          {
            :consumed => data["consumed"],
            :limit => data["quantity"] == -1 ? _("Unlimited") : data["quantity"]
          }
        data
      end

      option "--id", "ID", _("ID of activation key"),
             :attribute_name => :option_activation_key_id
      option "--name", "NAME", _("Name of activation key"),
             :attribute_name => :option_activation_key_name

      validate_options do
        any(:option_activation_key_id, :option_activation_key_name).required
      end

      build_options do |o|
        o.expand.only(:organizations)
        o.without(
                  :system_id,
                  :activation_key_id,
                  :full_results,
                  :search,
                  :order,
                  :sort,
                  :page,
                  :per_page
                 )
      end
    end

    class AddSubscriptionsCommand < HammerCLIKatello::SingleResourceCommand
      action :add_subscriptions

      desc "Add subscription"
      command_name "add-subscription"

      option "--subscription-id", "SUBSCRIPTION_ID", _("ID of subscription"),
             :attribute_name => :option_subscription_id, :required => true

      build_options do |o|
        o.expand.except(:subscriptions)
        o.without(:subscriptions)
      end

      success_message _("Subscription added to activation key")
      failure_message _("Could not add subscription to activation key")
    end

    class RemoveSubscriptionCommand < HammerCLIKatello::SingleResourceCommand
      action :remove_subscriptions

      desc _("Remove subscription")
      command_name "remove-subscription"

      option "--subscription-id", "SUBSCRIPTION_ID", _("ID of subscription"),
             :attribute_name => :option_subscription_id, :required => true

      build_options do |o|
        o.expand.except(:subscriptions)
        o.without(:subscriptions)
      end

      success_message _("Subscription removed from activation key")
      failure_message _("Could not remove subscription from activation key")
    end

    class HostCollectionsCommand < HammerCLIKatello::ListCommand
      resource :host_collections, :index

      desc _("List associated host collections")
      command_name "host-collections"

      output do
        field :id, _("ID")
        field :name, _("Name")
      end

      option "--id", "ID", _("ID of activation key"),
             :attribute_name => :option_activation_key_id
      option "--name", "NAME", _("Name of activation key"),
             :attribute_name => :option_activation_key_name

      validate_options do
        any(:option_activation_key_id, :option_activation_key_name).required
      end

      build_options do |o|
        o.expand.only(:organizations)
        o.without(
                  :system_id,
                  :activation_key_id,
                  :full_results,
                  :search,
                  :order,
                  :sort,
                  :page,
                  :per_page
                 )
      end
    end

    HammerCLIKatello::AssociatingCommands::HostCollection.extend_command(self)

    autoload_subcommands
  end

end
