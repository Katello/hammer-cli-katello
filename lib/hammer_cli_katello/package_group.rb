module HammerCLIKatello
  class PackageGroupCommand < HammerCLIKatello::Command
    resource :package_groups

    class ListCommand < HammerCLIKatello::ListCommand
      extend RepositoryScopedToProduct

      validate_repo_name_requires_product_options(:option_repository_name)

      output do
        field :id, _("ID")
        field :name, _("Package Group Name")
        field :repo_name, _("Repository Name")
        field :uuid, _("UUID")
      end

      def extend_data(data)
        data["repo_name"] = data["repository"]["name"]
        data
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Package Group Name")
        field :repo_name, _("Repository Name")
        field :uuid, _("UUID")
        field :description, _("Description")
        field :default_package_names, _("Default Packages"), Fields::List
        field :mandatory_package_names, _("Mandatory Packages"), Fields::List
        field :conditional_package_names, _("Conditional Packages"), Fields::List
        field :optional_package_names, _("Optional Packages"), Fields::List
      end

      def extend_data(data)
        data["repo_name"] = data["repository"]["name"]
        data
      end

      build_options
    end

    autoload_subcommands
  end
end
