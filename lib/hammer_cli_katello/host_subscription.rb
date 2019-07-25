require 'hammer_cli_katello/content_override'
require 'hammer_cli_katello/product_content'

module HammerCLIKatello
  class HostSubscription < HammerCLIKatello::Command
    desc "Manage subscription information on your hosts"

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      resource :host_subscriptions, :destroy
      command_name "unregister"

      success_message _("Host unregistered.")
      failure_message _("Could not unregister the host")

      build_options
    end

    class CreateCommand < HammerCLIKatello::SingleResourceCommand
      include LifecycleEnvironmentNameMapping
      include OrganizationOptions

      resource :host_subscriptions, :create
      command_name "register"
      success_message _("Host successfully registered.")
      failure_message _("Failed to register host")

      build_options do |o|
        o.expand(:all).except(:products)
        o.without(:facts, :installed_products)
      end

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class AddSubscriptions < HammerCLIKatello::SingleResourceCommand
      resource :host_subscriptions, :add_subscriptions
      command_name "attach"
      success_message _("Subscription attached to the host successfully.")
      failure_message _("Failed to attach subscriptions to the host")

      option "--subscription-id", "SUBSCRIPTION_ID", _("ID of subscription"),
             :attribute_name => :option_subscription_id, :required => true

      option "--quantity", "Quantity", _("Quantity of this subscriptions to add. Defaults to 1"),
             :attribute_name => :option_quantity, :required => false

      def request_params
        params = super
        params[:subscriptions] = [
          {
            :id => option_subscription_id,
            :quantity => option_quantity || 1
          }
        ]
        params
      end

      build_options do |o|
        o.expand.except(:subscriptions)
        o.without(:subscriptions)
      end
    end

    class AutoAttachSubscriptions < HammerCLIKatello::SingleResourceCommand
      resource :host_subscriptions, :auto_attach
      command_name "auto-attach"
      success_message _("Auto attached subscriptions to the host successfully.")
      failure_message _("Failed to auto attach subscriptions to the host")

      build_options
    end

    class RemoveSubscriptions < HammerCLIKatello::SingleResourceCommand
      resource :host_subscriptions, :remove_subscriptions
      command_name "remove"
      success_message _("Subscription removed from the host successfully.")
      failure_message _("Failed to remove subscriptions from the host")

      option "--subscription-id", "SUBSCRIPTION_ID", _("ID of subscription"),
             :attribute_name => :option_subscription_id, :required => true

      option "--quantity", "Quantity",
             _("Remove the first instance of a subscription with matching id and quantity"),
             :attribute_name => :option_quantity, :required => false

      def request_params
        params = super
        subs = { :id => option_subscription_id }
        subs[:quantity] = option_quantity if option_quantity
        params[:subscriptions] = [subs]
        params
      end

      build_options do |o|
        o.expand.except(:subscriptions)
        o.without(:subscriptions)
      end
    end

    class ProductContentCommand < HammerCLIKatello::ProductContentBase::ProductContentCommand
      resource :host_subscriptions, :product_content
      setup
    end

    class ContentOverrideCommand < ::HammerCLIKatello::ContentOverrideBase::ContentOverrideCommand
      resource :host_subscriptions, :content_override
      setup

      def request_params
        super.tap do |opts|
          opts.delete('value')
          opts.delete('content_label')
        end
      end

      build_options do |o|
        o.expand.except(:content_overrides, :content_label, :value)
        o.without(:content_overrides, :content_label, :value)
      end
    end

    autoload_subcommands
  end
end
