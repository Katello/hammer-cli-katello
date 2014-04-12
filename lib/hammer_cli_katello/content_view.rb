require 'hammer_cli_katello/content_view_puppet_module'
require 'hammer_cli_katello/filter'
require 'hammer_cli_katello/content_view_version'

module HammerCLIKatello

  class ContentView < HammerCLIKatello::Command
    resource :content_views

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("Content View ID")
        field :name, _("Name")
        field :label, _("Label")
        field :composite, _("Composite")
        field :repository_ids, _("Repository IDs"), Fields::List
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :label, _("Label")
        field :composite, _("Composite")
        field :description, _("Description")

        from :organization do
          field :name, _("Organization")
        end

        collection :repositories, _("Repositories") do
          field :id, _("ID")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :puppet_modules, _("Puppet Modules") do
          field :id, _("ID")
          field :uuid, _("UUID"), Fields::Field, :hide_blank => true
          field :name, _("Name")
          field :author, _("Author")
          field :created_at, _("Created"), Fields::Date
          field :updated_at, _("Updated"), Fields::Date
        end

        collection :environments, _("Environments") do
          field :id, _("ID")
          field :name, _("Name")
        end

        collection :versions, _("Versions") do
          field :id, _("ID")
          field :version, _("Version")
          field :published, _("Published"), Fields::Date
        end

        collection :components, _("Components") do
          field :id, _("ID")
          field :name, _("Name")
        end
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Content view created")
      failure_message _("Could not create the content view")

      option ["--composite"], :flag, _("Create a composite content view")
      apipie_options :without => ["composite"]

      def request_params
        super.tap do |opts|
          opts['composite'] = option_composite?
        end
      end
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Content view updated")
      failure_message _("Could not update the content view")

      apipie_options
    end

    class DeleteCommand < HammerCLIForemanTasks::AsyncCommand
      action :destroy
      command_name "delete"
      success_message _("Content view is being destroy with task %{id}s")
      failure_message _("Could not destroyed the content view")

      apipie_options
    end

    class PublishCommand < HammerCLIForemanTasks::AsyncCommand
      action :publish
      command_name "publish"

      success_message _("Content view is being published with task %{id}s")
      failure_message _("Could not publish the content view")

      apipie_options
    end

    class RemoveFromEnvironmentCommand < HammerCLIForemanTasks::AsyncCommand
      action :remove_from_environment
      command_name "remove-from-environment"

      success_message _("Content view is being removed from environment with task %{id}s")
      failure_message _("Could not remove the content view from environment")

      apipie_options
    end

    class RemoveCommand < HammerCLIForemanTasks::AsyncCommand
      # command to remove content view environments and versions from a content view.
      # corresponds to the UI screen.
      action :remove
      command_name "remove"

      option ["--content-view-version-ids"], "VERSION_IDS",
             _("Comma separated list of version ids to remove")
      option ["--environment-ids"], "ENVIRONMENT_IDS",
             _("Comma separated list of environment ids to remove")

      def request_params
        super.tap do |opts|
          %w(content_view_version_ids :environment_ids).each do |key|
            opts[key] = opts[key].split(",") if opts[key]
          end
        end
      end

      success_message _("Content view objects are being removed task %{id}s")
      failure_message _("Could not remove objects from content view")

      apipie_options :without => %w(content_view_version_ids  environment_ids)
    end

    class AddContentViewVersionCommand < HammerCLIKatello::AddAssociatedCommand
      command_name 'add-version'

      def self.setup_associated_identifier_options
        option '--version', 'VERSION_NAME', ' ',
               :attribute_name => :associated_name
        option '--version-id', 'VERSION_ID', ' ',
               :attribute_name => :associated_id
      end

      def association_name(plural = false)
        plural ? "components" : "component"
      end

      associated_resource :content_view_versions
      apipie_options

      success_message _("The component version has been added")
      failure_message _("Could not add version")
    end

    class RemoveContentViewVersionCommand < HammerCLIKatello::RemoveAssociatedCommand
      command_name 'remove-version'

      def self.setup_associated_identifier_options
        option '--version', 'VERSION_NAME', ' ',
               :attribute_name => :associated_name
        option '--version-id', 'VERSION_ID', ' ',
               :attribute_name => :associated_id
      end

      def association_name(plural = false)
        plural ? "components" : "component"
      end

      associated_resource :content_view_versions
      apipie_options

      success_message _("The component version has been removed")
      failure_message _("Could not remove version")
    end

    include HammerCLIKatello::AssociatingCommands::Repository

    autoload_subcommands

    subcommand 'puppet-module',
               HammerCLIKatello::ContentViewPuppetModule.desc,
               HammerCLIKatello::ContentViewPuppetModule

    subcommand HammerCLIKatello::Filter.command_name,
               HammerCLIKatello::Filter.desc,
               HammerCLIKatello::Filter

    subcommand HammerCLIKatello::ContentViewVersion.command_name,
               HammerCLIKatello::ContentViewVersion.desc,
               HammerCLIKatello::ContentViewVersion
  end
end

HammerCLI::MainCommand.subcommand "content-view", _("Manipulate content views."),
                                  HammerCLIKatello::ContentView
