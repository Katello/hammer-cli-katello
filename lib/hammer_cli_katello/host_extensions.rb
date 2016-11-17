require 'hammer_cli_foreman/host'
require 'hammer_cli_katello/host_errata'
require 'hammer_cli_katello/host_subscription'
require 'hammer_cli_katello/host_package'
require 'hammer_cli_katello/host_package_group'

module HammerCLIKatello
  module HostgroupInheritable
    def request_params
      params = super
      if option_hostgroup_id
        hostgroup = resolver.api.resource(:hostgroups).call(:show, id: option_hostgroup_id)
        params["host"]["content_facet_attributes"] ||= {}
        params["host"]["content_facet_attributes"].merge!(
          "content_view_id" => hostgroup["content_view_id"],
          "lifecycle_environment_id" => hostgroup["lifecycle_environment_id"]
        ) { |_key, old, _new| old }
      end
      params
    end
  end

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

    ::HammerCLIForeman::Host::CreateCommand.instance_eval do
      include HammerCLIKatello::HostgroupInheritable
    end
  end
end
