module HammerCLIKatello

  class PuppetModule < HammerCLIForeman::Command
    resource :puppet_modules

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "ID"
        field :name, "Name"
        field :version, "Version"
        field :author, "Author"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, "ID"
        field :name, "Name"
        field :version, "Version"
        field :author, "Author"

        field :summary, "Summary"
        field :description, "Description"
        field :license, "License"
        field :project_page, "Project Page"
        field :source, "Source"
        field :dependencies, "Dependencies", Fields::List
        field :checksums, "Checksums", Fields::List
        field :tag_list, "Tag List", Fields::List
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
