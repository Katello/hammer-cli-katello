require 'hammer_cli_katello/erratum_info_command'

module HammerCLIKatello
  class HostErrata < HammerCLIKatello::Command
    desc "Manage errata on your hosts"

    class ApplyCommand < HammerCLIKatello::SingleResourceCommand
      command_name "apply"

      def self.rex_feature
        "katello_errata_install"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    class ListCommand < HammerCLIKatello::ListCommand
      include OrganizationOptions
      include LifecycleEnvironmentNameMapping
      resource :host_errata, :index
      command_name "list"

      output do
        field :id, _("Id")
        field :errata_id, _("Erratum ID")
        field :type, _("Type")
        field :title, _("Title")
        field :installable, _("Installable")
      end

      build_options
      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class InfoCommand < HammerCLIKatello::ErratumInfoCommand
      resource :host_errata, :show
      build_options
    end

    class RecalculateCommand < HammerCLIKatello::SingleResourceCommand
      resource :host_errata, :applicability
      command_name "recalculate"
      success_message _("Errata recalculation started.")
      failure_message _("Could not recalculate errata")

      build_options
    end

    autoload_subcommands
  end
end
