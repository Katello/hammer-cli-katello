require 'hammer_cli_katello/content_view_puppet_module'
require 'hammer_cli_katello/filter'
require 'hammer_cli_katello/content_view_version'

module HammerCLIKatello

  class ContentView < HammerCLIKatello::Command
    resource :content_views

    class ListCommand < HammerCLIKatello::ListCommand
      include LifecycleEnvironmentNameResolvable
      output do
        field :id, _("Content View ID")
        field :name, _("Name")
        field :label, _("Label")
        field :composite, _("Composite")
        field :repository_ids, _("Repository IDs"), Fields::List
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :label, _("Label")
        field :composite, _("Composite")
        field :description, _("Description")
        field :content_host_count, _("Content Host Count")

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

        collection :activation_keys, _("Activation Keys") do
          custom_field Fields::Reference
        end
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Content view created")
      failure_message _("Could not create the content view")

      option ["--composite"], :flag, _("Create a composite content view")

      def request_params
        super.tap do |opts|
          opts['composite'] = option_composite?
        end
      end

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _("Content view updated")
      failure_message _("Could not update the content view")

      build_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include HammerCLIForemanTasks::Async

      action :destroy
      command_name "delete"

      success_message _("Content view is being deleted with task %{id}")
      failure_message _("Could not delete the content view")

      build_options
    end

    class PublishCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

      action :publish
      command_name "publish"

      success_message _("Content view is being published with task %{id}")
      failure_message _("Could not publish the content view")

      build_options
    end

    class RemoveFromEnvironmentCommand < HammerCLIKatello::SingleResourceCommand
      include LifecycleEnvironmentNameResolvable
      include HammerCLIForemanTasks::Async

      action :remove_from_environment
      command_name "remove-from-environment"

      success_message _("Content view is being removed from environment with task %{id}")
      failure_message _("Could not remove the content view from environment")

      build_options
    end

    class RemoveCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

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
          %w(content_view_version_ids environment_ids).each do |key|
            opts[key] = opts[key].split(",") if opts[key]
          end
        end
      end

      success_message _("Content view objects are being removed task %{id}")
      failure_message _("Could not remove objects from content view")

      build_options :without => %w(content_view_version_ids  environment_ids)
    end

    class AddContentViewVersionCommand < HammerCLIKatello::AddAssociatedCommand
      command_name 'add-version'

      def association_name(plural = false)
        plural ? "components" : "component"
      end

      associated_resource :content_view_versions
      build_options

      success_message _("The component version has been added")
      failure_message _("Could not add version")
    end

    class RemoveContentViewVersionCommand < HammerCLIKatello::RemoveAssociatedCommand
      command_name 'remove-version'

      def association_name(plural = false)
        plural ? "components" : "component"
      end

      associated_resource :content_view_versions
      build_options

      success_message _("The component version has been removed")
      failure_message _("Could not remove version")
    end

    HammerCLIKatello::AssociatingCommands::Repository.extend_command(self)

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
