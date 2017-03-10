module HammerCLIKatello
  class HostSubscription < HammerCLIKatello::Command
    desc "Manage subscription information on your hosts"

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      resource :host_subscriptions, :destroy
      command_name "unregister"

      success_message _("Host unregistered")
      failure_message _("Could not unregister the host")

      build_options
    end

    class CreateCommand < HammerCLIKatello::SingleResourceCommand
      include LifecycleEnvironmentNameResolvable
      include OrganizationOptions

      resource :host_subscriptions, :create
      command_name "register"
      success_message _("Host successfully registered")
      failure_message _("Failed to register host")

      build_options do |o|
        o.expand(:all).except(:products)
        o.without(:facts, :installed_products)
      end
    end

    class AddSubscriptions < HammerCLIKatello::SingleResourceCommand
      resource :host_subscriptions, :add_subscriptions
      command_name "attach"
      success_message _("Subscription attached to the host successfully")
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
      success_message _("Auto attached subscriptions to the host successfully")
      failure_message _("Failed to auto attach subscriptions to the host")

      build_options
    end

    class RemoveSubscriptions < HammerCLIKatello::SingleResourceCommand
      resource :host_subscriptions, :remove_subscriptions
      command_name "remove"
      success_message _("Subscription removed from the host successfully")
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

    class ContentOverrideCommand < HammerCLIKatello::SingleResourceCommand
      resource :host_subscriptions, :content_override

      desc _("Override product content defaults")
      command_name "content-override"

      success_message _("Updated content override")
      failure_message _("Could not update content override")

      option "--content-label", "CONTENT_LABEL", _("Label of the content"),
             :attribute_name => :option_content_label, :required => true

      option "--value", "VALUE", _("Override to yes/no, or ‘default’." \
                                   " Possible value(s): 'yes', 'no', 'default'"),
             :attribute_name => :option_value, :required => true

      def request_params
        params = super
        params[:content_overrides] = [
          {
            :content_label => option_content_label,
            :value => option_value
          }
        ]
        params
      end

      build_options do |o|
        o.expand.except(:content_overrides)
        o.without(:content_overrides)
      end
    end

    autoload_subcommands
  end
end
