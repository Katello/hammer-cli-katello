module HammerCLIKatello
  class ErratumInfoCommand < HammerCLIKatello::InfoCommand
    command_name "info"

    output do
      field :title, _("Title")
      field :version, _("Version")
      field :description, _("Description")
      field :status, _("Status")
      field :id, _("Id")
      field :errata_id, _("Errata ID")
      field :reboot_suggested, _("Reboot Suggested")
      field :updated, _("Updated")
      field :issued, _("Issued")
      field :release, _("Release")
      field :solution, _("Solution")
      field :packages, _("Packages"), Fields::List, :hide_blank => true

      collection :module_streams, _("Module Streams"), :hide_blank => true do
        field :name, _("Name")
        field :stream, _("Stream")
        field :packages, _("Packages"), Fields::List
      end
    end
  end
end
