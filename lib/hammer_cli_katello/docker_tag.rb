module HammerCLIKatello
  class DockerTagCommand < HammerCLIForeman::Command
    resource :docker_tags
    command_name 'tag'
    desc _('Manage docker tags')

    class ListCommand < HammerCLIKatello::ListCommand
      include HammerCLIKatello::LifecycleEnvironmentNameMapping

      output do
        field :id, _("ID")
        field :name, _("Tag")
        field :repository_id, _("Repository ID")
      end

      build_options do |o|
        o.expand.including(:products, :organizations, :content_views)
      end

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Tag")
        field :repository_id, _("Repository ID")

        from :manifest do
          field :id, _("Docker Manifest ID")
          field :name, _("Docker Manifest Name")
        end
      end

      build_options
    end

    autoload_subcommands
  end
end
