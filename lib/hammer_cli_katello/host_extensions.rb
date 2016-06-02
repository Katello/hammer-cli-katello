require 'hammer_cli_foreman/host'
require 'hammer_cli_katello/host_errata'
require 'hammer_cli_katello/host_subscription'
require 'hammer_cli_katello/host_package'
require 'hammer_cli_katello/host_package_group'

module HammerCLIKatello
  module HostExtensions
    ::HammerCLIForeman::Host::ListCommand.instance_eval do
      output do
        from :content_facet_attributes do
          field :content_view_name, _('Content View')
          field :lifecycle_environment_name, _('Lifecycle Environment')
        end
      end
    end

    ::HammerCLIForeman::Host::InfoCommand.instance_eval do
      output do
        label _('Content Information') do
          from :content_facet_attributes do
            field :content_view_name, _('Content View')
            field :lifecycle_environment_name, _('Lifecycle Environment')

            label _('Applicable Errata') do
              from :errata_counts do
                field :enhancement, _('Enhancement')
                field :bugfix, _('Bug Fix')
                field :security, _('Security')
              end
            end
          end
        end

        label _('Subscription Information') do
          from :subscription_facet_attributes do
            field :uuid, _('UUID')
            field :last_checkin, _('Last Checkin')
            field :service_level, _('Service Level')
            field :release_version, _('Release Version')
            field :autoheal, _('Autoheal')
            field :registered_at, _('Registered At')
          end
        end

        collection :host_collections, _('Host Collections') do
          field :id, _('Id')
          field :name, _('Name')
        end
      end
    end
  end
end
