require 'hammer_cli_katello/content_view_puppet_module'
require 'hammer_cli_katello/filter'

module HammerCLIKatello

  class ContentView < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::ContentView

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "Content View ID"
        field :name, "Name"
        field :label, "Label"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
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
          field :label, "Label"
        end

        collection :puppet_modules, "Puppet Modules" do
          field :id, "ID"
          field :uuid, "UUID"
          field :name, "Name"
          field :author, "Author"
          field :added, "Added"
          field :updated, "Updated"
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
      end

      apipie_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message "Content view created"
      failure_message "Could not create the content view"

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

    include HammerCLIKatello::AssociatingCommands::Repository

    autoload_subcommands

    subcommand 'puppet-module',
               HammerCLIKatello::ContentViewPuppetModule.desc,
               HammerCLIKatello::ContentViewPuppetModule

    subcommand 'filter',
               HammerCLIKatello::Filter.desc,
               HammerCLIKatello::Filter
  end
end

HammerCLI::MainCommand.subcommand "content-view", "Manipulate content views.",
                                  HammerCLIKatello::ContentView
