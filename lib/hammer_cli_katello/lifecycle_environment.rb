module HammerCLIKatello

  class LifecycleEnvironmentCommand < HammerCLIKatello::Command
    resource :lifecycle_environments

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :prior, _("Prior")
      end

      build_options
    end

    class PathsCommand < HammerCLIKatello::ListCommand
      action :paths
      command_name "paths"

      output do
        field :pretty_path, _("Lifecycle Path")
      end

      def extend_data(data)
        route = []
        data["path"].each { |step| route << step["environment"]["name"] }

        data[:pretty_path] = route.join(" >> ")
        data
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :label, _("Label")
        field :description, _("Description")
        from :organization do
          field :name, _("Organization")
        end
        field :library, _("Library")
        field :prior, _("Prior Lifecycle Environment")
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Environment created")
      failure_message _("Could not create environment")

      def request_params
        params = super
        params["prior"] = resolver.lifecycle_environment_id(
          HammerCLI.option_accessor_name("name") => params["prior"],
          HammerCLI.option_accessor_name("organization_id") => params["organization_id"]
        )
        params
      end

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Environment updated")
      failure_message _("Could not update environment")

      def request_params
        params = super
        params["prior"] = resolver.lifecycle_environment_id(
          HammerCLI.option_accessor_name("name") => params["prior"],
          HammerCLI.option_accessor_name("organization_id") => params["organization_id"]
        )
        params
      end

      build_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("Environment deleted")
      failure_message _("Could not delete environment")

      build_options
    end

    autoload_subcommands
  end

  cmd_name = "lifecycle-environment"
  cmd_desc = _("manipulate lifecycle_environments on the server")
  cmd_cls  = HammerCLIKatello::LifecycleEnvironmentCommand
  HammerCLI::MainCommand.subcommand(cmd_name, cmd_desc, cmd_cls)
end
