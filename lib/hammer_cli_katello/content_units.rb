module HammerCLIKatello
  class ContentUnitsCommand < HammerCLIKatello::Command
    resource :generic_content_units

    class ListCommand < HammerCLIKatello::ListCommand
      extend RepositoryScopedToProduct

      validate_repo_name_requires_product_options(:option_repository_name)

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :version, _("Version")
        field :filename, _("Filename"), Fields::Field, hide_blank: true
      end

      validate_options :before, 'IdResolution' do
        organization_options = %i[option_organization_id option_organization_name
                                  option_organization_label]
        if any(:option_product_name, :option_content_view_name).exist?
          any(*organization_options).required
        end
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
        field :filename, _("Filename"), Fields::Field, hide_blank: true
      end

      validate_options :before, 'IdResolution' do
        organization_options = %i[option_organization_id option_organization_name
                                  option_organization_label]
        product_options = %i[option_product_id option_product_name]
        repository_options = %i[option_repository_id option_repository_name]
        content_view_version_options = %i[option_content_view_version_id
                                          option_content_view_version_version]

        if option(:option_product_name).exist?
          any(*organization_options).required
        end

        if option(:option_repository_name).exist?
          any(*product_options).required
        end

        if option(:option_name).exist?
          any(*(repository_options + content_view_version_options)).required
        end
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views, :content_view_versions)
      end
    end

    autoload_subcommands
  end
end
