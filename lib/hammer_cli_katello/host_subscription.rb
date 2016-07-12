require 'hammer_cli_katello/content_view_name_resolvable'

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
      include HammerCLIKatello::ContentViewNameResolvable
      resource :host_subscriptions, :create
      command_name "register"
      success_message _("Host successfully registered")
      failure_message _("Failed to register host")

      build_options do |o|
        o.expand(:all).except(:products).including(:organizations)
        o.without(:facts, :installed_products)
      end
    end

    autoload_subcommands
  end
end
