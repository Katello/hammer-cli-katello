module HammerCLIKatello
  class PackageCommand < HammerCLIKatello::Command
    resource :packages

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :filename, _("Filename")
        field :sourcerpm, _("Source RPM")
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :version, _("Version")
        field :arch, _("Architecture")
        field :epoch, _("Epoch")
        field :release, _("Release")
        field :author, _("Author")
        field :filename, _("Filename")
        field :buildhost, _("Build Host")
        field :vendor, _("Vendor")
        field :license, _("License")
        field :relativepath, _("Relative Path")
        field :description, _("Description")
      end

      build_options
    end

    autoload_subcommands
  end
end
