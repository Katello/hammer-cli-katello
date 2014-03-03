module HammerCLIKatello

  class ContentViewPuppetModule < HammerCLI::Apipie::Command

    resource KatelloApi::Resources::ContentViewPuppetModule
    command_name 'puppet-module'
    desc 'View and manage puppet modules'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "ID"
        field :uuid, "UUID"
        field :name, "Name"
        field :author, "Author"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, "ID"
        field :uuid, "UUID"
        field :name, "Name"
        field :author, "Author"
        field :added, "Added"
        field :updated, "Updated"
      end

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::WriteCommand
      action :create
      command_name "add"

      success_message "Puppet module added to content view"
      failure_message "Could not add the puppet module"

      apipie_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message "Puppet module updated for content view"
      failure_message "Could not update the puppet module"

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    class DeleteCommand < HammerCLIKatello::WriteCommand
      action :destroy
      command_name "remove"

      success_message "Puppet module removed from content view"
      failure_message "Could not delete the filter"

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    autoload_subcommands
  end
end
