require 'hammer_cli_katello/erratum_info_command'

module HammerCLIKatello
  class HostErrata < HammerCLIKatello::Command
    desc "Manage errata on your hosts"

    class ApplyCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_errata, :apply
      command_name "apply"
      success_message _("Errata is being applied with task %{id}.")
      failure_message _("Could not apply errata")

      build_options
    end

    class ListCommand < HammerCLIKatello::ListCommand
      resource :host_errata, :index
      command_name "list"

      output do
        field :id, _("ID")
        field :errata_id, _("Erratum ID")
        field :type, _("Type")
        field :title, _("Title")
        field :installable, _("Installable")
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::ErratumInfoCommand
      resource :host_errata, :show
      build_options
    end

    class RecalculateCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_errata, :applicability
      command_name "recalculate"
      success_message _("Errata recalculated with task %{id}.")
      failure_message _("Could not recalculate errata")

      build_options
    end

    autoload_subcommands
  end
end
