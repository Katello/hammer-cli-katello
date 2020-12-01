module HammerCLIKatello
  class OstreeBranchCommand < HammerCLIKatello::Command
    resource :ostree_branches

    class ListCommand < HammerCLIKatello::ListCommand
      extend RepositoryScopedToProduct

      validate_repo_name_requires_product_options(:option_repository_name)

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :version, _("version")
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("Id")
        field :name, _("Name")
        field :version, _("Version")
        field :commit, _("Commit")
      end

      build_options
    end

    autoload_subcommands
  end
end
