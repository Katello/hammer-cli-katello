module HammerCLIKatello

  class ContentViewVersion < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::ContentViewVersion
    command_name 'version'
    desc 'View and manage content view versions'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "ID"
        field :name, "Name"
        field :version, "Version"

        from :content_view do
          field :id, "Content View ID"
          field :name, "Content View Name"
          field :label, "Content View Label"
        end
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, "ID"
        field :name, "Name"
        field :version, "Version"

        from :content_view do
          field :id, "Content View ID"
          field :name, "Content View Name"
          field :label, "Content View Label"
        end

        collection :environments, "Environments" do
          field :id, "ID"
          field :name, "Name"
          field :label, "Label"
        end
      end

      apipie_options
    end

    class PromoteCommand < HammerCLIKatello::WriteCommand
      action :promote
      command_name "promote"

      success_message "Content view promoted"
      failure_message "Could not promote the content view"

      apipie_options
    end

    autoload_subcommands
  end
end
