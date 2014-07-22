module HammerCLIKatello
  class ContentHostErrata < HammerCLIKatello::Command

    desc "Manage errata on your content hosts"

    class ApplyCommand < HammerCLIKatello::SingleResourceCommand
      resource :system_errata, :apply
      command_name "apply"
      success_message _("Errata applied successfully")
      failure_message _("Could not apply errata")

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :system_errata, :show
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
