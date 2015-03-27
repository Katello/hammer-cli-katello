module HammerCLIKatello

  class LifecycleEnvironmentCommand < HammerCLIKatello::Command
    resource :lifecycle_environments

    module PriorIdResolvable

      def self.included(base)
        base.option(
          "--prior",
          "PRIOR",
          _("Name of the prior enviroment")
        )
        base.validate_options do
          any(:option_prior, :option_prior_id).required
        end
      end

      def request_params
        params = super
        prior = params.delete("prior")
        if prior
          params["prior_id"] = resolver.lifecycle_environment_id(
            HammerCLI.option_accessor_name("name") => prior,
            HammerCLI.option_accessor_name("organization_id") => params["organization_id"]
          )
        end
        params
      end
    end

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        from :prior do
          field :name, _("Prior")
        end
      end

      build_options
    end

    class PathsCommand < HammerCLIKatello::ListCommand
      action :paths
      command_name "paths"

      output do
        field :_pretty_path, _("Lifecycle Path")
      end

      def extend_data(data)
        data["_pretty_path"] = data["environments"].map { |env| env["name"] }.join(" >> ")
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
        from :prior do
          field :name, _("Prior Lifecycle Environment")
        end
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      include PriorIdResolvable

      success_message _("Environment created")
      failure_message _("Could not create environment")

      build_options do |o|
        o.without(:prior)
      end
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      include PriorIdResolvable

      success_message _("Environment updated")
      failure_message _("Could not update environment")

      build_options do |o|
        o.without(:prior)
      end
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _("Environment deleted")
      failure_message _("Could not delete environment")

      build_options
    end

    autoload_subcommands
  end

end
