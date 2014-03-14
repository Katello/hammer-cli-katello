module HammerCLIKatello

  class LifecycleEnvironmentCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::Environment, :index

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :prior, _("Prior")
      end

      apipie_options
    end

    class PathsCommand < HammerCLIKatello::ListCommand
      resource KatelloApi::Resources::Environment, :paths

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

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource KatelloApi::Resources::Environment
      include HammerCLIKatello::ScopedNameCommand

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

      def request_params
        super.merge(method_options)
      end
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource KatelloApi::Resources::Environment, :create
      include HammerCLIKatello::ScopedName
      success_message _("Environment created")
      failure_message _("Could not create environment")

      apipie_options

      def execute
        self.option_prior = scoped_name_to_id(get_option_value(:prior), resource)
        super
      end
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Environment updated")
      failure_message _("Could not update environment")
      include HammerCLIKatello::ScopedNameCommand
      resource KatelloApi::Resources::Environment

      identifiers :id

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("Environment deleted")
      failure_message _("Could not delete environment")
      include HammerCLIKatello::ScopedNameCommand
      resource KatelloApi::Resources::Environment

      identifiers :id

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    autoload_subcommands
  end

  cmd_name = "lifecycle-environment"
  cmd_desc = _("manipulate lifecycle_environments on the server")
  cmd_cls  = HammerCLIKatello::LifecycleEnvironmentCommand
  HammerCLI::MainCommand.subcommand(cmd_name, cmd_desc, cmd_cls)
end
