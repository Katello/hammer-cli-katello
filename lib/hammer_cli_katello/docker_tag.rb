module HammerCLIKatello
  class DockerTagCommand < HammerCLIKatello::Command
    resource :docker_tags

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :tag, _("Tag")
        field :repository_id, _("Repository ID")
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :tag, _("Tag")
        field :repository_id, _("Repository ID")

        from :image do
          field :id, _("Docker Image ID")
        end
      end

      build_options
    end

    autoload_subcommands
  end
end
