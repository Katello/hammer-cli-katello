module HammerCLIKatello

  class ContentViewPuppetModule < HammerCLIKatello::Command

    resource :content_view_puppet_modules
    command_name 'puppet-module'
    desc 'View and manage puppet modules'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :uuid, _("UUID")
        field :name, _("Name")
        field :author, _("Author")
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :uuid, _("UUID"), Fields::Field, :hide_blank => true
        field :name, _("Name")
        field :author, _("Author")
        field :created_at, _("Created"), Fields::Date
        field :updated_at, _("Updated"), Fields::Date
      end

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::WriteCommand
      action :create
      command_name "add"

      success_message _("Puppet module added to content view")
      failure_message _("Could not add the puppet module")

      apipie_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Puppet module updated for content view")
      failure_message _("Could not update the puppet module")

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    class DeleteCommand < HammerCLIKatello::WriteCommand
      action :destroy
      command_name "remove"

      success_message _("Puppet module removed from content view")
      failure_message _("Could not delete the filter")

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    autoload_subcommands
  end
end
