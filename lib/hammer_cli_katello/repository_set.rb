module HammerCLIKatello

  class RepositorySetCommand < HammerCLI::AbstractCommand

    class ListCommand < HammerCLIKatello::ListCommand
      resource :repository_sets, :index

      output do
        field :id, _("ID")
        field :type, _("Type")
        field :name, _("Name"), nil, :max_width => 300
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :repository_sets, :show

      output do
        field :id, _("ID")
        field :name, _("Name")

        collection :repositories, _("Repositories") do
          field :id, _("ID")
          field :name, _("Name")
          field :enabled, _("Enabled"), Fields::Boolean
        end
      end

      build_options
    end

    class AvailableRepositoriesCommand < HammerCLIKatello::ListCommand
      resource :repository_sets, :available_repositories
      command_name "available-repositories"

      output do
        field :repo_name, _("Name")
        from :substitutions do
          field :basearch, _("Arch")
          field :releasever, _("Release")
        end
        field :enabled, _("Enabled"), Fields::Boolean
      end

      # build_options
    end

    class EnableCommand < HammerCLIKatello::UpdateCommand
      resource :repository_sets, :enable
      command_name "enable"

      success_message _("Repository enabled")
      failure_message _("Could not enable repository")

      build_options
    end

    class DisableCommand < HammerCLIKatello::UpdateCommand
      resource :repository_sets, :disable
      command_name "disable"

      success_message _("Repository disabled")
      failure_message _("Could not disable repository")

      build_options
    end

    autoload_subcommands
  end

  HammerCLI::MainCommand.subcommand("repository-set", _("manipulate repository sets on the server"),
                                    HammerCLIKatello::RepositorySetCommand)
end
