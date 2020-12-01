module HammerCLIKatello
  class HostDebPackage < HammerCLIKatello::Command
    desc "Manage deb packages on your hosts"

    class ListCommand < HammerCLIKatello::ListCommand
      resource :host_debs, :index

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :version, _("Version")
        field :architecture, _("Arch")
      end

      build_options
    end

    autoload_subcommands
  end
end
