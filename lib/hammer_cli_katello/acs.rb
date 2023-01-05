module HammerCLIKatello
  class AcsCommand < HammerCLIKatello::Command
    resource :alternate_content_sources

    class ListCommand < HammerCLIKatello::ListCommand
      output do
        field :id, _('ID')
        field :name, _('Name')
        field :alternate_content_source_type, _('Type')
      end

      build_options
    end

    class CreateCommand < HammerCLIKatello::CreateCommand
      success_message _('Alternate Content Source created.')
      failure_message _('Could not create the Alternate Content Source.')

      build_options do |o|
        o.expand(:all).except(:products)
        o.without(:product_name)
      end
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      output do
        field :id, _('ID')
        field :name, _('Name')
        field :label, _('Label')
        field :description, _('Description'), Fields::Field, :hide_blank => true
        field :base_url, _('Base URL')
        field :content_type, _('Content type')
        field :alternate_content_source_type, _('Alternate content source type')
        field :upstream_username, _('Upstream username'), Fields::Field, :hide_blank => true

        collection :subpaths, _('Subpaths') do
          field nil, _('')
        end

        collection :products, _('Products') do
          field :id, _('Id')
          field :organization_id, _('Organization ID')
          field :name, _('Name')
          field :label, _('Label')
        end

        collection :smart_proxies, _('Smart proxies') do
          field :id, _('Id')
          field :name, _('Name')
          field :url, _('URL')
          field :download_policy, _('Download policy')
        end
      end

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      success_message _('Alternate Content Source updated.')
      failure_message _('Could not update the Alternate Content Source.')

      build_options
    end

    class DeleteCommand < HammerCLIKatello::DeleteCommand
      success_message _('Alternate Content Source deleted.')
      failure_message _('Could not delete the Alternate Content Source.')

      build_options
    end

    class RefreshCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async

      action :refresh
      command_name 'refresh'

      success_message _("Alternate content source is being refreshed in task %{id}.")
      failure_message _('Could not refresh the alternate content source')

      build_options
    end
    autoload_subcommands
  end
end
