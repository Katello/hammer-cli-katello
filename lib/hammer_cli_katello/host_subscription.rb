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

    autoload_subcommands
  end
end
