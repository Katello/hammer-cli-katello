require 'hammer_cli_katello/content_view_puppet_module'
require 'hammer_cli_katello/filter'
require 'hammer_cli_katello/content_view_version'

module HammerCLIKatello

  class ContentView < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::ContentView

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
      apipie_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Content view updated")
      failure_message _("Could not update the content view")

      apipie_options
    end

    class PublishCommand < HammerCLIForemanTasks::AsyncCommand
      action :publish
      command_name "publish"

      success_message _("Content view is being published with task %{id}s")
      failure_message _("Could not publish the content view")

      apipie_options
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

      associated_resource KatelloApi::Resources::ContentViewVersion
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

      associated_resource KatelloApi::Resources::ContentViewVersion
      apipie_options

      success_message _("The component version has been removed")
      failure_message _("Could not remove version")
    end

    include HammerCLIKatello::AssociatingCommands::Repository

    autoload_subcommands

    subcommand 'puppet-module',
               HammerCLIKatello::ContentViewPuppetModule.desc,
               HammerCLIKatello::ContentViewPuppetModule

    subcommand 'filter',
               HammerCLIKatello::Filter.desc,
               HammerCLIKatello::Filter

    subcommand 'version',
               HammerCLIKatello::ContentViewVersion.desc,
               HammerCLIKatello::ContentViewVersion
  end
end

HammerCLI::MainCommand.subcommand "content-view", _("Manipulate content views."),
                                  HammerCLIKatello::ContentView
