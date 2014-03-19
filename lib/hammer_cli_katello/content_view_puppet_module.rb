module HammerCLIKatello

  class ContentViewPuppetModule < HammerCLIForeman::Command

    resource :content_view_puppet_modules
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
        field :uuid, "UUID", Fields::Field, :hide_blank => true
        field :name, "Name"
        field :author, "Author"
        field :created_at, "Created", Fields::Date
        field :updated_at, "Updated", Fields::Date
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
