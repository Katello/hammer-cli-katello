require 'hammer_cli_foreman/host'
require 'hammer_cli_katello/host_errata'
require 'hammer_cli_katello/host_subscription'
require 'hammer_cli_katello/host_package'
require 'hammer_cli_katello/host_package_group'
require 'hammer_cli_katello/host_kickstart_repository_options'
require 'hammer_cli_katello/host_content_source_options'

module HammerCLIKatello
  module HostExtensions
    ::HammerCLIForeman::Host::CreateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      include HammerCLIKatello::HostContentSourceOptions
      include ::HammerCLIKatello::HostKickstartRepositoryOptions
    end

    ::HammerCLIForeman::Host::UpdateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      include HammerCLIKatello::HostContentSourceOptions
      include ::HammerCLIKatello::HostKickstartRepositoryOptions
    end

    ::HammerCLIForeman::Host::ListCommand.instance_eval do
      output do
        from :content_facet_attributes do
          field :content_view_name, _('Content View')
          field :lifecycle_environment_name, _('Lifecycle Environment')
          from :errata_counts do
            field :security, _("Security"), nil, :sets => ['ALL']
            field :bugfix, _("Bugfix"), nil, :sets => ['ALL']
            field :enhancement, _("Enhancement"), nil, :sets => ['ALL']
          end
        end
      end
    end

    ::HammerCLIForeman::Host::InfoCommand.instance_eval do
      output do
        label _('Content Information') do
          from :content_facet_attributes do
            label _("Content View") do
              field :content_view_id, _("ID")
              field :content_view_name, _("Name")
            end

            label _("Lifecycle Environment") do
              field :lifecycle_environment_id, _("ID")
              field :lifecycle_environment_name, _("Name")
            end

            label _("Content Source") do
              field :content_source_id, _("ID")
              field :content_source_name, _("Name")
            end

            label _("Kickstart Repository") do
              field :kickstart_repository_id, _("ID")
              field :kickstart_repository_name, _("Name")
            end

            field :applicable_package_count, _('Applicable Packages')
            field :upgradable_package_count, _('Upgradable Packages')

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
            field :registered_through, _('Registered To')
            field :registered_at, _('Registered At')
            collection :activation_keys, _('Registered by Activation Keys'), :hide_blank => true do
              custom_field Fields::Reference
            end
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
