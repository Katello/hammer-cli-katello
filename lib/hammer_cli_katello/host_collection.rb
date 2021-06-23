module HammerCLIKatello
  class HostCollection < HammerCLIKatello::Command
    resource :host_collections

    module LimitFieldDataExtension
      def extend_data(data)
        data['_limit'] = data['unlimited_hosts'] ? 'None' : data['max_hosts']
        data
      end
    end

    module HostCollectionUpdateHostsErrorHandler
      def execute
        response = send_request
        if response['error'].any?
          print_message(failure_message)
          puts response['error'].join("\n")
          HammerCLI::EX_CANTCREAT
        else
          print_data(response)
          HammerCLI::EX_OK
        end
      end
    end

    class ListCommand < HammerCLIKatello::ListCommand
      include LimitFieldDataExtension
      resource :host_collections, :index

      output do
        field :id, _("Id")
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

      success_message _("Host collection created.")
      failure_message _("Could not create the host collection")

      option "--unlimited-hosts", :flag, "Set hosts max to unlimited"

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include LimitFieldDataExtension
      resource :host_collections, :show

      output ListCommand.output_definition do
        field :total_hosts, _("Total Hosts")
      end

      build_options { |o| o.expand(:all).including(:organizations) }
    end

    class HostsCommand < HammerCLIKatello::ListCommand
      resource :hosts, :index
      command_name "hosts"

      option "--id", "HOST_COLLECTION_ID", _("Host Collection ID"),
             :attribute_name => :option_host_collection_id
      option "--name", "HOST_COLLECTION_NAME", _("Host Collection Name"),
             :attribute_name => :option_host_collection_name

      validate_options :before, 'IdResolution' do
        host_collection_options = [:option_host_collection_id, :option_host_collection_name]
        any(*host_collection_options).required
      end

      def host_collection_options
        {
          "option_name" => option_host_collection_name,
          "option_organization_name" => option_organization_name,
          "option_organization_id" => option_organization_id,
          "option_organization_label" => option_organization_label
        }
      end

      def request_params
        params = super
        host_collection_id = option_host_collection_id
        unless option_host_collection_name.nil?
          host_collection_id = resolver.host_collection_id(
            options.merge(resolver.scoped_options("host_collection", options)))
        end
        params['search'] = "host_collection_id=#{host_collection_id}"
        params
      end

      output do
        field :id, _("Id")
        field :name, _("Name")
        from :content_facet_attributes do
          from :errata_counts do
            field :security, _("Security"), nil, :sets => ['ALL']
            field :bugfix, _("Bugfix"), nil, :sets => ['ALL']
            field :enhancement, _("Enhancement"), nil, :sets => ['ALL']
          end
        end
      end

      build_options { |o| o.expand(:all).including(:organizations) }
    end

    class CopyCommand < HammerCLIKatello::CreateCommand
      action :copy
      command_name "copy"
      desc _("Copy a host collection")

      option "--new-name", "NEW_NAME", _("New host collection name"), required: true

      success_message _("New host collection created.")
      failure_message _("Could not create the new host collection")

      def request_params
        params = super
        # This is a hack to keep Hammer consistent without changing the inconsistent API V2
        params['name'] = options[HammerCLI.option_accessor_name('new_name')] if params['id']
        params
      end

      build_options { |o| o.expand(:all).including(:organizations) }
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Host collection updated.")
      failure_message _("Could not update the the host collection")

      build_options { |o| o.expand(:all).including(:organizations) }
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      resource :host_collections, :destroy

      success_message _("Host collection deleted.")
      failure_message _("Could not delete the host collection")

      build_options { |o| o.expand(:all).including(:organizations) }
    end

    class AddHostCommand < HammerCLIKatello::SingleResourceCommand
      include HostCollectionUpdateHostsErrorHandler

      command_name 'add-host'
      action :add_hosts

      success_message _("The host(s) has been added.")
      failure_message _("Could not add host(s)")

      build_options { |o| o.expand(:all).including(:organizations) }
    end

    class RemoveHostCommand < HammerCLIKatello::SingleResourceCommand
      include HostCollectionUpdateHostsErrorHandler

      command_name 'remove-host'
      action :remove_hosts

      success_message _("The host(s) has been removed.")
      failure_message _("Could not remove host(s)")

      build_options { |o| o.expand(:all).including(:organizations) }
    end

    autoload_subcommands

    class ContentBaseCommand < Command
      resource :hosts_bulk_actions

      option "--id", "HOST_COLLECTION_ID", _("Host Collection ID"),
             :attribute_name => :option_host_collection_id
      option "--name", "HOST_COLLECTION_NAME", _("Host Collection Name"),
             :attribute_name => :option_host_collection_name

      build_options do |o|
        o.expand(:all).including(:organizations)
      end

      def request_params
        params = super

        host_collection_id = resolver.host_collection_id(
          'option_id' => option_host_collection_id,
          'option_name' => option_host_collection_name,
          'option_organization_id' => params['organization_id']
        )

        params['content'] = content
        params['content_type'] = content_type
        params['included'] = { search: "host_collection_id=\"#{host_collection_id}\"" }
        params
      end

      def resolver
        custom_resolver = Class.new(HammerCLIKatello::IdResolver) do
          def hosts_bulk_action_id(options)
            host_collection_id(options)
          end
        end
        custom_resolver.new(HammerCLIKatello.api_connection, HammerCLIKatello::Searchables.new)
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
