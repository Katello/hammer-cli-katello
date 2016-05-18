module HammerCLIKatello
  class ErratumCommand < HammerCLIKatello::Command
    resource :errata

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :errata_id, _("Errata ID")
        field :type, _("Type")
        field :title, _("Title")
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :errata_id, _("Errata ID")
        field :title, _("Title")
        field :type, _("Type")
        field :severity, _("Severity")
        field :issued, _("Issued")
        field :updated, _("Updated")
        field :description, _("Description")
        field :summary, _("Summary")
        field :solution, _("Solution")
      end

      build_options
    end

    autoload_subcommands
  end
end
