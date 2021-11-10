module HammerCLIKatello
  class SrpmCommand < HammerCLIKatello::Command
    resource :srpms

    class ListCommand < HammerCLIKatello::ListCommand
      include LifecycleEnvironmentNameMapping
      output do
        field :id, _("Id")
        field :name, _("Name")
        field :filename, _("Filename")
      end

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]
        product_options = [:option_product_id, :option_product_name]
        content_view_options = [:option_content_view_id, :option_content_view_name]

        if option(:option_product_name).exist? || option(:option_content_view_name).exist?
          any(*organization_options).required
        end

        if option(:option_repository_name).exist?
          any(*product_options).required
        end

        if option(:option_content_view_version_version).exist?
          any(*content_view_options).required
        end

        if any(*content_view_options).exist?
          any(:option_content_view_version_id,
              :option_content_view_version_version,
              :option_environment_id,
              :option_environment_name).required
        end
      end

      build_options do |o|
        o.expand.including(:products, :content_views)
      end

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("Id")
        field :name, _("Name")
        field :version, _("Version")
        field :arch, _("Architecture")
        field :epoch, _("Epoch")
        field :release, _("Release")
        field :filename, _("Filename")
        field :summary, _("Description")
      end

      build_options
    end

    autoload_subcommands
  end
end
