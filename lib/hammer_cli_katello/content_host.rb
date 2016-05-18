module HammerCLIKatello
  class ContentHostCommand < HammerCLI::AbstractCommand
    module IdDescriptionOverridable
      def self.included(base)
        base.option "--id", "ID",
                    _("ID of the content host")
      end
    end

    class ListCommand < HammerCLIKatello::ListCommand
      include KatelloEnvironmentNameResolvable
      resource :systems, :index

      output do
        field :uuid, _("ID")
        field :name, _("Name")
        from :errata_counts do
          field :total, _("Installable Errata")
        end
      end

      build_options
    end

    class InfoCommand < HammerCLIKatello::InfoCommand
      include KatelloEnvironmentNameResolvable
      include IdDescriptionOverridable
      resource :systems, :show

      output do
        field :name, _("Name")
        field :uuid, _("ID")
        field :katello_agent_installed, _("Katello Agent Installed"), Fields::Boolean
        field :location, _("Location")
        from :environment do
          field :name, _("Lifecycle Environment")
        end
        from :content_view do
          field :name, _("Content View")
        end
        field :entitlementStatus, _("Entitlement Status")
        field :release_ver, _("Release Version")
        field :autoheal, _("Autoheal")
        from :errata_counts do
          field :security, _("Security Errata")
          field :bugfix, _("Bugfix Errata")
          field :enhancement, _("Enhancement Errata")
        end
      end

      build_options
    end

    class UpdateCommand < HammerCLIKatello::UpdateCommand
      include IdDescriptionOverridable
      include KatelloEnvironmentNameResolvable
      resource :systems, :update

      success_message _("Content host updated")
      failure_message _("Could not update content host")

      def request_params
        params = super
        params.delete('facts')
        params
      end

      build_options :without => [:facts, :type, :installed_products]
    end

    class AvailableIncrementalUpdates < HammerCLIKatello::ListCommand
      resource :systems_bulk_actions, :available_incremental_updates
      command_name 'available-incremental-updates'

      option("--id", "ID", _("ID of a content host"))

      def extend_data(data)
        data['environments'] = data['environments'].map { |env| env['name'] }.join(',')
        data
      end

      output do
        from :content_view_version do
          from :content_view do
            field :name, _("Name")
          end
          field :version, _("Version")
        end

        field :environments, _("Environments")
      end

      def request_params
        params = super
        params.delete('exclude')
        params.delete('ids')

        params[:ids] = params[:id]
        params.delete('id')

        params
      end

      build_options :without => [:id]
    end

    autoload_subcommands
  end
end
