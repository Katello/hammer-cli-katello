module HammerCLIKatello

  class ContentViewVersion < HammerCLIKatello::Command
    resource :content_view_versions
    command_name 'version'
    desc 'View and manage content view versions'

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :version, _("Version")

        from :content_view do
          field :id, _("Content View ID")
          field :name, _("Content View Name")
          field :label, _("Content View Label")
        end
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :version, _("Version")

        from :content_view do
          field :id, _("Content View ID")
          field :name, _("Content View Name")
          field :label, _("Content View Label")
        end

        collection :environments, _("Environments") do
          field :id, _("ID")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :repositories, _("Repositories") do
          field :id, _("ID")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :puppet_modules, _("Puppet Modules") do
          field :id, _("ID")
          field :name, _("Name")
          field :author, _("Author")
          field :version, _("Version")
        end
      end

      build_options
    end

    class PromoteCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

      action :promote
      command_name "promote"

      success_message _("Content view is being promoted with task %{id}")
      failure_message _("Could not promote the content view")

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

    autoload_subcommands
  end
end
