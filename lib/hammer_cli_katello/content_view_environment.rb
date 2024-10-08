module HammerCLIKatello
  class ContentViewEnvironment < HammerCLIKatello::Command
    resource :content_view_environments

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Id")
        field :label, _("Label")
        from :environment do
          field :name, _("Lifecycle Environment")
        end
        from :content_view do
          field :name, _("Content View")
        end
        field :default, _("Default")
        field :hosts_count, _("Hosts Count")
        from :organization do
          field :name, _("Organization")
        end
      end

      build_options
    end

    autoload_subcommands
  end
end
