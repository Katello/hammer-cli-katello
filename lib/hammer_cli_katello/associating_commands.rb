module HammerCLIKatello
  module AssociatingCommands
    module Repository
      module AddProductOptions
        def dependencies
          dependency_resolver.resource_dependencies(associated_resource,
                                                    :only_required => false,
                                                    :recursive => true)
        end

        def create_option_builder
          super.tap do |option_builder|
            products = dependencies.find { |r| r.name == :products }
            if products
              option_builder.builders << HammerCLIForeman::DependentSearchablesOptionBuilder.new(
                products, searchables)
            end
          end
        end
      end

      extend HammerCLIForeman::AssociatingCommands::CommandExtension

      class AddRepositoryCommand < HammerCLIKatello::AddAssociatedCommand
        extend AddProductOptions
        include RepositoryScopedToProduct
        command_name 'add-repository'
        associated_resource :repositories

        def validate_options
          super
          validator.any(:option_repository_id, :option_repository_name).required
        end

        success_message _("The repository has been associated")
        failure_message _("Could not add repository")
      end

      class RemoveRepositoryCommand < HammerCLIKatello::RemoveAssociatedCommand
        extend AddProductOptions
        include RepositoryScopedToProduct
        command_name 'remove-repository'
        associated_resource :repositories

        def validate_options
          super
          validator.any(:option_repository_id, :option_repository_name).required
        end

        success_message _("The repository has been removed")
        failure_message _("Could not remove repository")
      end
    end

    module HostCollection
      extend HammerCLIForeman::AssociatingCommands::CommandExtension

      class AddHostCollectionCommand < HammerCLIKatello::AddAssociatedCommand
        command_name 'add-host-collection'
        associated_resource :host_collections

        def request_params
          all_options['option_host_collection_organization_id'] ||= option_organization_id
          super
        end

        success_message _("The host collection has been associated")
        failure_message _("Could not add host collection")
      end

      class RemoveHostCollectionCommand < HammerCLIKatello::RemoveAssociatedCommand
        command_name 'remove-host-collection'
        associated_resource :host_collections

        def request_params
          all_options['option_host_collection_organization_id'] ||= option_organization_id
          super
        end

        success_message _("The host collection has been removed")
        failure_message _("Could not remove host collection")
      end
    end

    module Host
      extend HammerCLIForeman::AssociatingCommands::CommandExtension

      class AddHostCommand < HammerCLIKatello::AddAssociatedCommand
        command_name 'add-host'
        associated_resource :hosts

        success_message _("The host has been added")
        failure_message _("Could not add host")
      end

      class RemoveHostCommand < HammerCLIKatello::RemoveAssociatedCommand
        command_name 'remove-host'
        associated_resource :hosts

        success_message _("The host has been removed")
        failure_message _("Could not remove host")
      end
    end
  end
end
