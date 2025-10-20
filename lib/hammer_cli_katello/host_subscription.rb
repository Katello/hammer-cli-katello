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

    class ProductContentCommand < HammerCLIKatello::ProductContentBase::ProductContentCommand
      resource :host_subscriptions, :product_content
      setup
    end

    class EnabledRepositoriesCommand < HammerCLIKatello::ListCommand
      resource :host_subscriptions, :enabled_repositories
      command_name 'enabled-repositories'

      output do
        field :id, _('ID')
        field :name, _('Name')
        field :label, _('Label')
        field :content_type, _('Content type')
        field :checksum, _("Checksum")

        from :content_view do
          field :id, _('Content View id')
          field :name, _("Content View name")
        end

        from :content_view_version do
          field :name, _("Content View version")
        end

        from :kt_environment do
          field :name, _("Environment name")
        end

        from :product do
          field :name, _("Product name")
        end
      end

      build_options
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
