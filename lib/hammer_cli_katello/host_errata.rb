module HammerCLIKatello
  class HostErrata < HammerCLIKatello::Command

    desc "Manage errata on your hosts"

    class ApplyCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_errata, :apply
      command_name "apply"
      success_message _("Errata applied successfully")
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
        field :available, _("Installable")
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :host_errata, :show
      command_name "info"

      output do
        field :title, _("Title")
        field :version, _("Version")
        field :description, _("Description")
        field :status, _("Status")
        field :id, _("ID")
        field :errata_id, _("Errata ID")
        field :reboot_suggested, _("Reboot Suggested")
        field :updated, _("Updated")
        field :issued, _("Issued")
        field :release, _("Release")
        field :solution, _("Solution")
        field :packages, _("Packages"), Fields::List
      end

      build_options
    end

    autoload_subcommands
  end
end
