module HammerCLIKatello
  class RepositorySetCommand < HammerCLI::AbstractCommand
    module Validations
      def validate_repository_set
        validate_options :before, 'IdResolution' do
          any(:option_id, :option_name).required
          if option(:option_name).exist?
            any(
              :option_organization_id, :option_organization_name, :option_organization_label,
              :option_product_id, :option_product_name
            ).required
          end
        end
      end
    end

    class ListCommand < HammerCLIKatello::ListCommand
      resource :repository_sets, :index

      output do
        field :id, _("ID")
        field :type, _("Type")
        field :name, _("Name"), nil, :max_width => 300
      end

      validate_options do
        any(
          :option_organization_id, :option_organization_name, :option_organization_label
        ).required
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      resource :repository_sets, :show
      extend Validations

      output do
        field :id, _("ID")
        field :name, _("Name")
        field :type, _("Type")
        field :contentUrl, _("URL")
        field :gpgUrl, _("GPG Key")
        field :label, _("Label")

        collection :repositories, _("Enabled Repositories") do
          field :id, _("ID")
          field :name, _("Name")
        end
      end

      validate_repository_set

      build_options
    end

    class AvailableRepositoriesCommand < HammerCLIKatello::ListCommand
      resource :repository_sets, :available_repositories
      command_name "available-repositories"
      extend Validations

      output do
        field :name, _("Name")
        from :substitutions do
          field :basearch, _("Arch")
          field :releasever, _("Release")
        end
        field :registry_name, _("Registry Name")
        field :enabled, _("Enabled"), Fields::Boolean
      end

      validate_repository_set

      # We need to define +custom_option_builders+ and +request_params+ to
      # be able to resolve the --name to --id for repository set
      def self.custom_option_builders
        super + [HammerCLIForeman::SearchablesOptionBuilder.new(resource, searchables)]
      end

      def request_params
        super.update('id' => get_identifier)
      end

      build_options
    end

    class EnableCommand < HammerCLIKatello::Command
      resource :repository_sets, :enable
      command_name "enable"
      extend Validations

      validate_repository_set

      success_message _("Repository enabled.")
      failure_message _("Could not enable repository")

      build_options
    end

    class DisableCommand < HammerCLIKatello::Command
      resource :repository_sets, :disable
      command_name "disable"
      extend Validations

      validate_repository_set

      success_message _("Repository disabled.")
      failure_message _("Could not disable repository")

      build_options
    end

    autoload_subcommands
  end
end
