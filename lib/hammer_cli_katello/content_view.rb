require 'hammer_cli_katello/filter'

module HammerCLIKatello

  class ContentView < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::ContentView

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "Content View ID"
        field :name, "Name"
        field :label, "Label"
        field :composite, "Composite"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, "ID"
        field :name, "Name"
        field :label, "Label"
        field :composite, "Composite"
        field :description, "Description"

        from :organization do
          field :name, "Organization"
        end

        collection :repositories, "Repositories" do
          field :id, "ID"
          field :name, "Name"
          field :label, "Label"
        end

        collection :environments, "Environments" do
          field :id, "ID"
          field :name, "Name"
        end

        collection :versions, "Versions" do
          field :id, "ID"
          field :version, "Version"
          field :published, "Published", Fields::Date
        end

        collection :components, "Components" do
          field :id, "ID"
          field :name, "Name"
        end
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message "Content view created"
      failure_message "Could not create the content view"

      option ["--composite"], :flag, "Create a composite content view"
      apipie_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message "Content view updated"
      failure_message "Could not update the content view"

      apipie_options
    end

    class PublishCommand < HammerCLIKatello::WriteCommand
      action :publish
      command_name "publish"

      success_message "Content view published"
      failure_message "Could not publish the content view"

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
    end

    # rubocop:disable LineLength
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
    end

    include HammerCLIKatello::AssociatingCommands::Repository

    autoload_subcommands
    subcommand 'filter', HammerCLIKatello::Filter.desc, HammerCLIKatello::Filter
  end
end

HammerCLI::MainCommand.subcommand "content-view", "Manipulate content views.",
                                  HammerCLIKatello::ContentView
