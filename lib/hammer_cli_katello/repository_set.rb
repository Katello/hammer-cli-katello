module HammerCLIKatello

  class RepositorySetCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIKatello::ListCommand
      resource :repository_sets, :index

      output do
        field :id, _("ID")
        field :_enabled, _("Enabled")
        field :name, _("Name")
      end

      def extend_data(data)
        data["_enabled"] = data["katello_enabled"] ? _("enabled") : _("disabled")
        data
      end

      def adapter
        :csv
      end

      apipie_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :repository_sets, :show

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :_enabled, _("Enabled")

        collection :repositories, _("Repositories") do
          field :id, _("ID")
          field :name, _("Name")
          field :_enabled, _("Enabled")
        end
      end

      def request_params
        super.merge(method_options)
      end

      def retrieve_data
        super.tap do |data|
          data["_enabled"] = data["katello_enabled"] ? _("yes") : _("no")
          data["repositories"].each do |repo|
            repo["_enabled"] = repo["enabled"] ? _("yes") : _("no")
          end
        end
      end

      apipie_options
    end

    class EnableCommand < HammerCLIKatello::UpdateCommand
      resource :repository_sets, :enable
      command_name "enable"

      success_message _("Repository set enabled")
      failure_message _("Could not enable repository set")

      apipie_options
    end

    class DisableCommand < HammerCLIKatello::UpdateCommand
      resource :repository_sets, :disable
      command_name "disable"

      success_message _("Repository set disabled")
      failure_message _("Could not disable repository set")

      apipie_options
    end

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand("repository-set", _("manipulate repository sets on the server"),
                                    HammerCLIKatello::RepositorySetCommand)
end
