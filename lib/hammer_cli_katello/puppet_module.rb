module HammerCLIKatello

  class PuppetModule < HammerCLIKatello::Command
    resource :puppet_modules

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _("ID")
        field :name, _("Name")
        field :author, _("Author")
        field :version, _("Version")
      end

      build_options
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

        collection :dependencies, _("Dependencies"), :numbered => false do
          field nil, nil, HammerCLIKatello::Output::Fields::Dependency
        end
        collection :checksums, _("File checksums"), :numbered => false do
          field nil, nil, HammerCLIKatello::Output::Fields::ChecksumFilePair
        end

        field :tag_list, _("Tag List"), Fields::List

        collection :repositories, _("Repositories") do
          field :id, _("Id")
          field :name, _("Name")
        end
      end

      build_options do |o|
        o.expand(:all).including(:organizations)
      end
    end

    autoload_subcommands
  end
end
