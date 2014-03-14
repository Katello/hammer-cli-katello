module HammerCLIKatello

  class PackageGroup < HammerCLI::Apipie::Command
    resource KatelloApi::Resources::PackageGroup

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, "ID"
        field :name, "Name"
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, "ID"
        field :name, "Name"
        field :description, "Description"

        field :default_package_names, "Default Package Names", Fields::List
        field :mandatory_package_names, "Mandatory Package Names", Fields::List
        field :conditional_package_names, "Conditional Package Names", Fields::List
        field :optional_package_names, "Optional Package Names", Fields::List
      end

      def request_params
        super.merge(method_options)
      end

      apipie_options
    end

    autoload_subcommands
  end
end

HammerCLI::MainCommand.subcommand "package-group",
                                  "View Package Group details.",
                                  HammerCLIKatello::PackageGroup
