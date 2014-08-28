module HammerCLIKatello

  class ErratumCommand < HammerCLIKatello::Command
    resource :errata

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :errata_id, _("Errata ID")
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
        field :issued, _("Issued")
      end

      build_options
    end

    autoload_subcommands
  end
end
