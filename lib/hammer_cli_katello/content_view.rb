require 'hammer_cli_katello/content_view_purge'
require 'hammer_cli_katello/filter'
require 'hammer_cli_katello/content_view_version'
require 'hammer_cli_katello/content_view_component'

module HammerCLIKatello
  class ContentView < HammerCLIKatello::Command
    resource :content_views

    class ListCommand < HammerCLIKatello::ListCommand
      include LifecycleEnvironmentNameMapping

      output do
        field :id, _("Content View ID")
        field :name, _("Name")
        field :label, _("Label")
        field :composite, _("Composite"), Fields::Boolean
        field :last_published, _("Last Published"), Fields::Date, :hide_blank => true
        field :repository_ids, _("Repository IDs"), Fields::List, :max_width => 300
      end

      build_options

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include OrganizationOptions
      # rubocop:disable Layout/LineLength

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :label, _("Label")
        field :composite, _("Composite"), Fields::Boolean
        field :description, _("Description")
        field :content_host_count, _("Content Host Count")
        field :solve_dependencies, _("Solve Dependencies"), Fields::Boolean

        from :organization do
          field :name, _("Organization")
        end

        collection :_yum_repositories, _("Yum Repositories"), hide_blank: true, hide_empty: true do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :_file_repositories, _("File Repositories"), hide_blank: true, hide_empty: true do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :_docker_repositories, _("Container Image Repositories"), hide_blank: true, hide_empty: true do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :_ostree_repositories, _("OSTree Repositories"), hide_blank: true, hide_empty: true do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :_ansible_collection_repositories, _("Ansible Repositories"), hide_blank: true, hide_empty: true do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :_file_repositories, _("File Repositories"), hide_blank: true, hide_empty: true do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :_deb_repositories, _("Debian Repositories"), hide_blank: true, hide_empty: true do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :_python_repositories, _("Python Repositories"), hide_blank: true, hide_empty: true do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :environments, _("Lifecycle Environments") do
          field :id, _("Id")
          field :name, _("Name")
        end

        collection :versions, _("Versions") do
          field :id, _("Id")
          field :version, _("Version")
          field :published, _("Published"), Fields::Date
        end

        collection :cv_components, _("Components"), hide_blank: true, hide_empty: true do
          field :id, _("Id")
          field :name, _("Name")
          field :latest, _("Latest version"), Fields::Boolean
          field :unpublished, _("Not yet published"), Fields::Boolean
          field :always_latest, _("Always update to the latest"), Fields::Boolean
        end

        collection :activation_keys, _("Activation Keys"), hide_blank: true, hide_empty: true do
          custom_field Fields::Reference
        end
      end

      def extend_data(data)
        %w(yum docker ostree file deb ansible_collection python).each do |content_type|
          data["_#{content_type}_repositories"] = data["repositories"].select do |repo|
            repo["content_type"] == content_type
          end
        end

        if data["composite"]
          data["cv_components"] = data["content_view_components"]&.map do |component|
            cv_latest = component.dig("content_view", "latest_version")
            {
              "id" => component.dig("content_view_version", "id"),
              "name" => component.dig("content_view_version", "name") || component.dig("content_view", "name"),
              "always_latest" => component["latest"],
              "latest" => cv_latest == component.dig("content_view_version", "version"),
              "unpublished" => component["content_view_version"].nil?
            }
          end
        end
        data
      end

      build_options
    end
    # rubocop:enable Layout/LineLength

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _("Content view created.")
      failure_message _("Could not create the content view")

      option ["--composite"], :flag, _("Create a composite content view")
      option ["--import-only"], :flag, _("Designate this Content View for "\
                                         "importing from upstream servers only.")
      def request_params
        super.tap do |opts|
          opts['composite'] = option_composite? || false
          opts['import_only'] = option_import_only? || false
        end
      end

      build_options do |o|
        o.expand.except(:repositories)
      end
    end

    class CopyCommand < HammerCLIKatello::CreateCommand
      include OrganizationOptions

      action :copy

      desc _("Copy a content view")
      command_name "copy"

      option "--name", "NAME", _("Content view name to search by"), :attribute_name => :option_name
      option "--new-name", "NEW_NAME", _("New content view name"),
             :attribute_name => :option_new_name

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]

        if option(:option_name).exist?
          any(*organization_options).required
        end
      end

      def request_params
        super.tap do |opts|
          opts['name'] = option_new_name
        end
      end

      build_options

      success_message _("Content view copied.")
      failure_message _("Could not copy the content view")
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      include OrganizationOptions

      success_message _("Content view updated.")
      failure_message _("Could not update the content view")

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]

        if option(:option_name).exist? || option(:option_product_name).exist?
          any(*organization_options).required
        end
      end

      build_options do |o|
        o.expand.except(:repositories)
      end
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      include HammerCLIForemanTasks::Async
      include OrganizationOptions

      action :destroy
      command_name "delete"

      success_message _("Content view is being deleted with task %{id}.")
      failure_message _("Could not delete the content view")

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]

        if option(:option_name).exist?
          any(*organization_options).required
        end
      end

      build_options
    end

    class PublishCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      include OrganizationOptions

      action :publish
      command_name "publish"

      success_message _("Content view is being published with task %{id}.")
      failure_message _("Could not publish the content view")

      build_options

      option_family associate: 'lifecycle_environment' do
        child '--lifecycle-environments', 'LIFECYCLE_ENVIRONMENT_NAMES',
              _('Names for Lifecycle Environment'),
              format: HammerCLI::Options::Normalizers::List.new,
              attribute_name: :option_environment_names
      end

      extend_with(
        HammerCLIKatello::CommandExtensions::LifecycleEnvironments.new(only: :option_sources)
      )
    end

    class RemoveFromEnvironmentCommand < HammerCLIKatello::SingleResourceCommand
      include LifecycleEnvironmentNameMapping
      include HammerCLIForemanTasks::Async
      include OrganizationOptions

      action :remove_from_environment
      command_name "remove-from-environment"

      success_message _("Content view is being removed from environment with task %{id}.")
      failure_message _("Could not remove the content view from environment")

      build_options

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironment.new)
    end

    class CVEnvParamsSource < HammerCLI::Options::Sources::Base
      def initialize(command)
        @command = command
      end

      def get_options(_defined_options, result)
        result['option_content_view_id'] = @command.option_id
        result['option_lifecycle_environment_names'] = result['option_environment_names']
        result
      end
    end

    class RemoveCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      include OrganizationOptions
      include LifecycleEnvironmentNameMapping

      # command to remove content view environments and versions from a content view.
      # corresponds to the UI screen.
      action :remove
      command_name "remove"

      def option_sources
        sources = super
        sources.find_by_name('IdResolution').insert_relative(
          :after,
          'IdParams',
          CVEnvParamsSource.new(self)
        )
        sources
      end

      def request_params
        super.tap do |opts|
          %w(content_view_version_ids environment_ids).each do |key|
            opts[key] = opts[key].split(",") if opts[key] && opts[key].respond_to?(:split)
          end
        end
      end

      success_message _("Content view objects are being removed task %{id}.")
      failure_message _("Could not remove objects from content view")

      build_options

      extend_with(HammerCLIKatello::CommandExtensions::LifecycleEnvironments.new)
    end

    class AddContentViewVersionCommand < HammerCLIKatello::AddAssociatedCommand
      include OrganizationOptions

      command_name 'add-version'
      desc _('Add a content view version to a composite view')

      option_family do
        parent "--content-view-id", "CONTENT_VIEW_ID",
               _("Content view id to search by"),
               attribute_name: :option_content_view_id,
               format: HammerCLI::Options::Normalizers::Number.new
        child "--content-view", "CONTENT_VIEW_NAME",
              _("Content view name to search by"),
              attribute_name: :option_content_view_name
      end

      validate_options :before, 'IdResolution' do
        if option(:option_content_view_version_version).exist?
          any(:option_content_view_id, :option_content_view_name).required
        end
      end

      def association_name(plural = false)
        plural ? "components" : "component"
      end

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]

        if option(:option_name).exist?
          any(*organization_options).required
        end
      end

      associated_resource :content_view_versions

      build_options do |o|
        o.expand.including(:content_views)
      end

      success_message _("The component version has been added.")
      failure_message _("Could not add version")
    end

    class RemoveContentViewVersionCommand < HammerCLIKatello::RemoveAssociatedCommand
      include OrganizationOptions

      command_name 'remove-version'
      desc _('Remove a content view version from a composite view')

      validate_options :before, 'IdResolution' do
        if option(:option_content_view_version_version).exist?
          any(:option_content_view_id, :option_content_view_name).required
        end
      end

      def association_name(plural = false)
        plural ? "components" : "component"
      end

      validate_options :before, 'IdResolution' do
        organization_options = [:option_organization_id, :option_organization_name, \
                                :option_organization_label]

        if option(:option_name).exist?
          any(*organization_options).required
        end
      end

      associated_resource :content_view_versions

      build_options do |o|
        o.expand.including(:content_views)
      end

      success_message _("The component version has been removed.")
      failure_message _("Could not remove version")
    end

    HammerCLIKatello::AssociatingCommands::Repository.extend_command(self)

    autoload_subcommands

    subcommand HammerCLIKatello::Filter.command_name,
               HammerCLIKatello::Filter.desc,
               HammerCLIKatello::Filter

    subcommand HammerCLIKatello::ContentViewVersion.command_name,
               HammerCLIKatello::ContentViewVersion.desc,
               HammerCLIKatello::ContentViewVersion

    subcommand HammerCLIKatello::ContentViewComponent.command_name,
               HammerCLIKatello::ContentViewComponent.desc,
               HammerCLIKatello::ContentViewComponent

    subcommand HammerCLIKatello::ContentViewPurgeCommand.command_name,
               HammerCLIKatello::ContentViewPurgeCommand.desc,
               HammerCLIKatello::ContentViewPurgeCommand
  end
end
