module HammerCLIKatello

  class HostCollection < HammerCLI::AbstractCommand
    class ListCommand < HammerCLIKatello::ListCommand
      resource :host_collections, :index

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :max_content_hosts, _("Limit")
        field :description, _("Description")
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource :host_collections, :create

      success_message _("Host collection created")
      failure_message _("Could not create the host collection")

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :host_collections, :show

      output ListCommand.output_definition do
        field :total_content_hosts, _("Total Content Hosts")
        field :max_content_hosts, _("Max Content Hosts")
      end

      build_options
    end

    class CopyCommand < HammerCLIKatello::CreateCommand
      success_message _("Host collection created")
      failure_message _("Could not create the host collection")
      command_name "copy"
      action :copy

      validate_options do
        all(:option_name).required unless option(:option_id).exist?
      end
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      resource :host_collections, :destroy

      success_message _("Host collection deleted")
      failure_message _("Could not delete the host collection")

      build_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand 'host-collection', _("Manipulate host collections"),
                                  HammerCLIKatello::HostCollection
