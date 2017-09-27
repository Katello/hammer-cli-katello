module HammerCLIKatello
  class FileCommand < HammerCLIKatello::Command
    resource :file_units

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :path, _("Path")
      end

      validate_options do
        organization_options = [:option_organization_id, :option_organization_name,
                                :option_organization_label]
        product_options = [:option_product_id, :option_product_name]

        if any(:option_product_name, :option_content_view_name).exist?
          any(*organization_options).required
        end

        if option(:option_repository_name).exist?
          any(*product_options).required
        end
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :path, _("Path")
        field :uuid, _("UUID")
        field :checksum, _("Checksum")
      end

      validate_options do
        organization_options = [:option_organization_id, :option_organization_name,
                                :option_organization_label]
        product_options = [:option_product_id, :option_product_name]
        repository_options = [:option_repository_id, :option_repository_name]
        content_view_version_options = [:option_content_view_version_id,
                                        :option_content_view_version_version]

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

      def all_options
        super.merge(options)
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views, :content_view_versions)
      end
    end

    autoload_subcommands
  end
end
