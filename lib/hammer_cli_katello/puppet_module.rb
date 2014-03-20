module HammerCLIKatello

  class PuppetModule < HammerCLIKatello::Command
    resource :puppet_modules

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :version, _("Version")
        field :author, _("Author")
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :version, _("Version")
        field :author, _("Author")

        field :summary, _("Summary")
        field :description, _("Description")
        field :license, _("License")
        field :project_page, _("Project Page")
        field :source, _("Source")
        field :dependencies, _("Dependencies"), Fields::List
        field :checksums, _("Checksums"), Fields::List
        field :tag_list, _("Tag List"), Fields::List
      end

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "puppet-module",
                                  "View Puppet Module details.",
                                  HammerCLIKatello::PuppetModule
