module HammerCLIKatello

  class OstreeBranchCommand < HammerCLIKatello::Command
    resource :ostree_branches

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :version, _("version")
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
        field :commit, _("Commit")
        field :version_date, _("Date")
      end

      build_options
    end

    autoload_subcommands
  end
end
