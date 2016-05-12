module HammerCLIKatello
  class PackageGroupCommand < HammerCLIKatello::Command
    resource :package_groups

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :description, _("Description")
        field :default_package_names, _("Default Packages"), Fields::List
        field :mandatory_package_names, _("Mandatory Packages"), Fields::List
        field :conditional_package_names, _("Conditional Packages"), Fields::List
        field :optional_package_names, _("Optional Packages"), Fields::List
      end

      build_options
    end

    autoload_subcommands
  end
end
