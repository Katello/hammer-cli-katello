module HammerCLIKatello

  class ContentViewVersion < HammerCLIForeman::Command
    resource :content_view_versions
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

        collection :repositories, "Repositories" do
          field :id, "ID"
          field :name, "Name"
          field :label, "Label"
        end

        collection :puppet_modules, "Puppet Modules" do
          field :id, "ID"
          field :name, "Name"
          field :author, "Author"
          field :version, "Version"
        end
      end

      apipie_options
    end

    class PromoteCommand < HammerCLIForemanTasks::AsyncCommand
      action :promote
      command_name "promote"

      success_message "Content view is being promoted with task %{id}s"
      failure_message "Could not promote the content view"

      apipie_options
    end

    autoload_subcommands
  end
end
