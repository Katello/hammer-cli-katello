module HammerCLIKatello
  class DockerManifestCommand < HammerCLIForeman::Command
    resource :docker_manifests
    command_name 'manifest'
    desc _('Manage docker manifests')

    class ListCommand < HammerCLIKatello::ListCommand
      include HammerCLIKatello::LifecycleEnvironmentNameMapping

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :schema_version, _("Schema Version")
        field :digest, _("Digest")
        field :downloaded, _("Downloaded"), Fields::Boolean
        field :_tags, _("Tags")
      end

      def extend_data(manifest)
        manifest['_tags'] = manifest['tags'].map { |e| e["name"] }.join(", ")
        manifest
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views)
      end

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :schema_version, _("Schema Version")
        field :digest, _("Digest")
        field :downloaded, _("Downloaded"), Fields::Boolean
        collection :tags, _("Tags") do
          field :name, _("Name")
        end
      end

      def extend_data(manifest)
        manifest['_tags'] = manifest['tags'].map { |e| { name: e["name"] } }.join(", ")
        manifest
      end

      build_options
    end

    autoload_subcommands
  end
end
