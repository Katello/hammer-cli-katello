module HammerCLIKatello
  class ContentViewEnvironment < HammerCLIKatello::Command
    resource :content_view_environments

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Id")
        field :label, _("Label")
        from :lifecycle_environment do
          field :name, _("Lifecycle Environment")
        end
        from :content_view do
          field :name, _("Content View")
        end
        field :default, _("Default")
        field :hosts_count, _("Hosts Count")
        field :activation_keys_count, _("Activation Keys Count")
        field :hostgroups_count, _("Hostgroups Count")
        from :organization do
          field :name, _("Organization")
        end
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      action :show

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :label, _("Label")
        field :default, _("Default"), Fields::Boolean
        field :created_at, _("Created At")
        field :updated_at, _("Updated At")
        from :organization do
          field :id, _("Organization Id")
          field :name, _("Organization")
          field :label, _("Organization Label")
        end
        from :content_view do
          field :id, _("Content View Id")
          field :name, _("Content View")
          field :label, _("Content View Label")
          field :default, _("Default Content View"), Fields::Boolean
        end
        from :lifecycle_environment do
          field :id, _("Lifecycle Environment Id")
          field :name, _("Lifecycle Environment")
          field :label, _("Lifecycle Environment Label")
          field :library, _("Library"), Fields::Boolean
        end
        field :hosts_count, _("Hosts Count")
        field :activation_keys_count, _("Activation Keys Count")
        field :hostgroups_count, _("Hostgroups Count")

        collection :activation_keys, _("Activation Keys"), :hide_blank => true, :hide_empty => true do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :hostgroups, _("Hostgroups"), :hide_blank => true, :hide_empty => true do
          field :id, _("Id")
          field :name, _("Name")
          field :title, _("Title")
        end
      end

      build_options
    end

    autoload_subcommands
  end
end
