require 'hammer_cli_foreman/organization'

module HammerCLIKatello
  class Organization < HammerCLIForeman::Organization
    class ListCommand < HammerCLIForeman::Organization::ListCommand
      include HammerCLIKatello::ResolverCommons
      resource :organizations, :index

      output do
        field :label, _("Label")
        field :description, _("Description")
      end

      build_options
    end

    class InfoCommand < HammerCLIForeman::Organization::InfoCommand
      include HammerCLIKatello::ResolverCommons
      resource :organizations, :show

      output do
        field :label, _("Label")
        field :description, _("Description")
        field :redhat_repository_url, _("Red Hat Repository URL")
        field :service_levels, _("Service Levels"), Fields::List
      end

      build_options
    end

    class UpdateCommand < HammerCLIForeman::Organization::UpdateCommand
      include HammerCLIKatello::ResolverCommons
      resource :organizations, :update

      success_message _("Organization updated")
      failure_message _("Could not update the organization")

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource :organizations, :create

      success_message _("Organization created")
      failure_message _("Could not create the organization")

      build_options
    end

    class DeleteCommand < HammerCLIForeman::Organization::DeleteCommand
      include HammerCLIKatello::ResolverCommons
      include HammerCLIForemanTasks::Async
      resource :organizations, :destroy

      success_message _("Organization deleted")
      failure_message _("Could not delete the organization")

      build_options
    end

    autoload_subcommands
  end
end
