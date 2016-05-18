module HammerCLIKatello
  class HostCollection < HammerCLIKatello::Command
    resource :host_collections

    module LimitFieldDataExtension
      def extend_data(data)
        data['_limit'] = data['unlimited_hosts'] ? 'None' : data['max_hosts']
        data
      end
    end

    class ListCommand < HammerCLIKatello::ListCommand
      include LimitFieldDataExtension
      resource :host_collections, :index

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :_limit, _("Limit")
        field :description, _("Description")
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      resource :host_collections, :create
      def request_params
        super.tap do |params|
          if params['max_hosts'] && params['unlimited_hosts'].nil?
            params['unlimited_hosts'] = false
          end
        end
      end

      success_message _("Host collection created")
      failure_message _("Could not create the host collection")

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include LimitFieldDataExtension
      resource :host_collections, :show

      output ListCommand.output_definition do
        field :total_hosts, _("Total Hosts")
      end

      build_options
    end

    class HostsCommand < HammerCLIKatello::ListCommand
      resource :host_collections, :hosts
      command_name "hosts"

      output do
        field :id, _("ID")
        field :name, _("Name")
      end

      build_options
    end

    class CopyCommand < HammerCLIKatello::CreateCommand
      resource :host_collections, :copy

      action :copy
      command_name "copy"

      success_message _("Host collection created")
      failure_message _("Could not create the host collection")

      validate_options do
        all(:option_name).required unless option(:option_id).exist?
      end

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Host collection updated")
      failure_message _("Could not update the the host collection")

      build_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      resource :host_collections, :destroy

      success_message _("Host collection deleted")
      failure_message _("Could not delete the host collection")

      build_options
    end

    class AddHostCommand < HammerCLIKatello::SingleResourceCommand
      command_name 'add-host'
      action :add_hosts

      success_message _("The host(s) has been added")
      failure_message _("Could not add host(s)")

      build_options
    end

    class RemoveHostCommand < HammerCLIKatello::SingleResourceCommand
      command_name 'remove-host'
      action :remove_hosts

      success_message _("The host(s) has been removed")
      failure_message _("Could not remove host(s)")

      build_options
    end

    autoload_subcommands

    class ContentBaseCommand < DeleteCommand
      resource :systems_bulk_actions

      build_options do |o|
        o.without(:content_type, :content, :ids, :search)
      end

      def request_params
        params = super
        params['content'] = content
        params['content_type'] = content_type
        params['included'] = { :search => "host_collection_ids:#{params['id']}" }
        params.delete('id')
        params
      end

      def resolver
        api = HammerCLI::Connection.get("foreman").api
        custom_resolver = Class.new(HammerCLIKatello::IdResolver) do
          def systems_bulk_action_id(options)
            host_collection_id(options)
          end
        end
        custom_resolver.new(api, HammerCLIKatello::Searchables.new)
      end
    end

    class InstallContentBaseCommand < ContentBaseCommand
      action :install_content
      command_name "install"
    end

    class UpdateContentBaseCommand < ContentBaseCommand
      action :update_content
      command_name "update"
    end

    class RemoveContentBaseCommand < ContentBaseCommand
      action :remove_content
      command_name "remove"
    end

    require 'hammer_cli_katello/host_collection_package'
    subcommand HammerCLIKatello::HostCollectionPackageCommand.command_name,
               HammerCLIKatello::HostCollectionPackageCommand.desc,
               HammerCLIKatello::HostCollectionPackageCommand

    require 'hammer_cli_katello/host_collection_package_group'
    subcommand HammerCLIKatello::HostCollectionPackageGroupCommand.command_name,
               HammerCLIKatello::HostCollectionPackageGroupCommand.desc,
               HammerCLIKatello::HostCollectionPackageGroupCommand

    require 'hammer_cli_katello/host_collection_erratum'
    subcommand HammerCLIKatello::HostCollectionErratumCommand.command_name,
               HammerCLIKatello::HostCollectionErratumCommand.desc,
               HammerCLIKatello::HostCollectionErratumCommand
  end
end
