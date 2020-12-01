module HammerCLIKatello
  class ModuleStreamCommand < HammerCLIKatello::Command
    resource :module_streams

    class ListCommand < HammerCLIKatello::ListCommand
      extend RepositoryScopedToProduct

      desc "List module streams"

      validate_repo_name_requires_product_options(:option_repository_name)

      output do
        field :id, _("Id")
        field :name, _("Module Stream Name")
        field :stream, _("Stream")
        field :uuid, _("Uuid")
        field :version, _("Version")
        field :arch, _("Architecture")
        field :context, _("Context")
      end

      build_options do |o|
        o.expand.including(:products)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      extend RepositoryScopedToProduct

      validate_repo_name_requires_product_options(:option_repository_name)

      output do
        field :id, _("Id")
        field :name, _("Module Stream Name")
        field :stream, _("Stream")
        field :uuid, _("Uuid")
        field :version, _("Version")
        field :arch, _("Architecture")
        field :context, _("Context")

        collection :repositories, _("Repositories") do
          field :id, _("Id")
          field :name, _("Name")
          field :label, _("Label")
        end

        collection :artifacts, _("Artifacts") do
          field :id, _("Id")
          field :name, _("Name")
        end

        collection :profiles, _("Profiles") do
          field :id, _("Id")
          field :name, _("Name")
          collection :rpms, _("RPMs") do
            field :id, _("Id")
            field :name, _("Name")
          end
        end
      end

      build_options do |o|
        o.expand.including(:products, :organizations)
      end
    end

    autoload_subcommands
  end
end
