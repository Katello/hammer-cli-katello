require 'hammer_cli_katello/erratum_info_command'

module HammerCLIKatello
  class ErratumCommand < HammerCLIKatello::Command
    resource :errata

    class ListCommand < HammerCLIKatello::ListCommand
      extend RepositoryScopedToProduct
      include LifecycleEnvironmentNameMapping

      validate_repo_name_requires_product_options(:option_repository_name)

      output do
        field :id, _("Id")
        field :errata_id, _("Errata ID")
        field :type, _("Type")
        field :title, _("Title")
        field :issued, _("Issued")
        field :updated, _("Updated")
      end

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]
        content_view_options = [:option_content_view_id, :option_content_view_name]

        if option(:option_product_name).exist? || option(:option_content_view_name).exist?
          any(*organization_options).required
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
        o.expand.including(:products, :organizations, :content_views)
      end
      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class InfoCommand < HammerCLIKatello::ErratumInfoCommand
      resource :errata
      build_options
    end

    autoload_subcommands
  end
end
