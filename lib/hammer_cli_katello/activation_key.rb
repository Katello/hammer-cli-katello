require 'hammer_cli_katello/content_override'
require 'hammer_cli_katello/product_content'

module HammerCLIKatello
  class ActivationKeyCommand < HammerCLIKatello::Command
    resource :activation_keys

    class ListCommand < HammerCLIKatello::ListCommand
      include LifecycleEnvironmentNameMapping

      action :index

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :format_consumed, _("Host Limit")
        field :content_view_environment_labels, _("Content View Environments"),
                                              Fields::List, :max_width => 300
        field :multi_content_view_environment, _("Multi Content View Environment"), Fields::Boolean
      end

      def extend_data(data)
        limit = data["unlimited_hosts"] ? _("Unlimited") : data["max_hosts"]

        data["format_consumed"] = _("%{consumed} of %{limit}") %
                                  {
                                    :consumed => data["usage_count"],
                                    :limit => limit
                                  }
        data
      end

      build_options

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      action :show

      def request_params
        params = super
        if options.keys.any? { |o| o.match(/\Aoption_organization.*/) }
          params['organization_id'] = resolver.organization_id(
            resolver.scoped_options('organization', all_options)
          )
        end
        params
      end

      output do
        field :name, _("Name")
        field :id, _("Id")
        field :description, _("Description"), Fields::Field, :hide_blank => true
        field :format_consumed, _("Host Limit")
        field :multi_content_view_environment, _("Multi Content View Environment"), Fields::Boolean
        field :release_version, _("Release Version"), Fields::Field, :hide_blank => true
        field :content_view_environment_labels, _("Content View Environment Labels"), Fields::Field

        collection :organization, _("Organization") do
          field :id, _("Id"), Fields::Field, :hide_blank => true
          field :name, _("Name"), Fields::Field, :hide_blank => true
        end

        collection :content_view_environments, _('Content View Environments') do
          from :content_view do
            label _("Content View") do
              field :id, _("Id")
              field :name, _("Name")
              field :content_view_version, _("Version")
              field :content_view_version_id, _("Content View version Id")
              field :composite, _("Composite"), Fields::Boolean
              field :content_view_environment_id, _("Content View Environment id"), Fields::Field
            end
          end
          from :lifecycle_environment do
            label _("Lifecycle environment") do
              field :id, _("Id")
              field :name, _("Name")
            end
          end
          field :label, _("Label")
        end

        collection :hosts, _("Associated Hosts"), hide_blank: true, hide_empty: true do
          field :id, _('Id'), Fields::Field, :hide_blank => true
          field :name, _("Name"), Fields::Field, :hide_blank => true
        end

        collection :host_collections, _("Host Collections"), hide_blank: true, hide_empty: true do
          field :id, _("Id"), Fields::Field, :hide_blank => true
          field :name, _("Name"), Fields::Field, :hide_blank => true
        end

        collection :content_overrides, _("Content Overrides"), hide_blank: true, hide_empty: true do
          field :content_label, _("Content Label"), Fields::Field, :hide_blank => true
          field :name, _("Name"), Fields::Field, :hide_blank => true
          field :value, _("Value"), Fields::Field, :hide_blank => true
        end

        label _("System Purpose"), hide_blank: true, hide_empty: true do
          field :service_level, _('Service Level'), Fields::Field, :hide_blank => true
          field :purpose_usage, _('Purpose Usage'), Fields::Field, :hide_blank => true
          field :purpose_role, _('Purpose Role'), Fields::Field, :hide_blank => true
          field :purpose_addons, _('Purpose Addons'), Fields::List, :hide_blank => true
        end
      end

      def extend_data(data)
        # rubocop:disable Layout/LineLength
        # Hack to hide purpose addons if it's not set since it's not possible to hide the Fields::List values
        data["purpose_addons"].length.positive? ? data["purpose_addons"] = data["purpose_addons"] : data["purpose_addons"] = nil
        limit = data["unlimited_hosts"] ? _("Unlimited") : data["max_hosts"]

        data["format_consumed"] = _("%{consumed} of %{limit}") %
                                  {
                                    :consumed => data["usage_count"],
                                    :limit => limit
                                  }
        data
        # rubocop:enable Layout/LineLength
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      include LifecycleEnvironmentNameMapping

      action :create
      success_message _("Activation key created.")
      failure_message _("Could not create the activation key")

      option "--unlimited-hosts", :flag, "Set hosts max to unlimited"

      validate_options :before, 'IdResolution' do
        all(:option_unlimited_hosts, :option_max_hosts).rejected
      end

      build_options

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class CopyCommand < HammerCLIKatello::CreateCommand
      action :copy

      desc _("Copy an activation key")
      command_name "copy"

      build_options

      success_message _("Activation key copied.")
      failure_message _("Could not copy the activation key")
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      include LifecycleEnvironmentNameMapping

      action :update
      success_message _("Activation key updated.")
      failure_message _("Could not update the activation key")

      option "--unlimited-hosts", :flag, "set hosts max to unlimited"

      validate_options do
        all(:option_unlimited_hosts, :option_max_hosts).rejected
      end

      build_options

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      action :destroy
      success_message _("Activation key deleted.")
      failure_message _("Could not delete the activation key")

      build_options
    end

    class SubscriptionsCommand < HammerCLIKatello::ListCommand
      resource :subscriptions, :index
      desc _("List associated subscriptions")
      command_name "subscriptions"

      output do
        field :id, _("Id")
        field :product_name, _("Name")
        field :format_consumed, _("Attached")
        field :quantity_attached, _("Quantity")
        field :start_date, _("Start Date"), Fields::Date
        field :end_date, _("End Date"), Fields::Date
        field :support_level, _("Support")
        field :contract_number, _("Contract")
        field :account_number, _("Account")
      end

      def extend_data(data)
        data["format_consumed"] = _("#{data['consumed']} out of "\
				    "#{data['quantity'] == -1 ? 'Unlimited' : data['quantity']}")
        data
      end

      option '--id', "ACTIVATION_KEY_ID", _("ID of the activation key"),
        attribute_name: :option_activation_key_id
      option '--name', "ACTIVATION_KEY_NAME", _("Activation key name to search by"),
        attribute_name: :option_activation_key_name

      validate_options :before, 'IdResolution' do
        any(:option_activation_key_id, :option_activation_key_name).required
      end

      build_options
    end

    class AddSubscriptionsCommand < HammerCLIKatello::SingleResourceCommand
      action :add_subscriptions

      desc "Add subscription"
      command_name "add-subscription"

      build_options

      success_message _("Subscription added to activation key.")
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

      success_message _("Subscription removed from activation key.")
      failure_message _("Could not remove subscription from activation key")
    end

    class ProductContentCommand < HammerCLIKatello::ProductContentBase::ProductContentCommand
      resource :activation_keys, :product_content
      setup
    end

    class ContentOverrideCommand < ::HammerCLIKatello::ContentOverrideBase::ContentOverrideCommand
      resource :activation_keys, :content_override
      setup

      build_options do |o|
        o.without(:content_overrides)
      end
    end

    class HostCollectionsCommand < HammerCLIKatello::ListCommand
      resource :host_collections, :index

      desc _("List associated host collections")
      command_name "host-collections"

      output do
        field :id, _("Id")
        field :name, _("Name")
      end

      option "--id", "ID", _("ID of activation key"),
             :attribute_name => :option_activation_key_id
      option "--name", "NAME", _("Name of activation key"),
             :attribute_name => :option_activation_key_name

      validate_options :before, 'IdResolution' do
        any(:option_activation_key_id, :option_activation_key_name).required
      end

      build_options do |o|
        o.expand.only(:organizations)
        o.without(
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
