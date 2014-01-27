require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli_foreman/commands'

module HammerCLIKatello

  class ContentView < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::ContentView

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, "Content View ID"
        field :name, "Name"
        field :label, "Label"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      output do
        field :id, "ID"
        field :name, "Name"
        field :label, "Label"
        field :description, "Description"

        from :organization do
          field :name, "Organization"
        end

        collection :repositories, "Repositories" do
          field :id, "ID"
          field :name, "Name"
        end

        collection :environments, "Environments" do
          field :id, "ID"
          field :name, "Name"
        end
      end

      apipie_options
    end

    class CreateCommand < HammerCLIForeman::CreateCommand
      success_message "Content view created"
      failure_message "Could not create the content view"

      apipie_options
    end

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      success_message "Content view updated"
      failure_message "Could not update the content view"

      apipie_options
    end

    class PublishCommand < HammerCLIForeman::WriteCommand
      action :publish
      command_name "publish"

      success_message "Content view published"
      failure_message "Could not publish the content view"

      apipie_options
    end

    include HammerCLIKatello::AssociatingCommands::Repository

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "content_view", "Manipulate content views.",
                                  HammerCLIKatello::ContentView
