require 'hammer_cli_foreman/host'
require 'hammer_cli_katello/host_errata'
require 'hammer_cli_katello/host_subscription'
require 'hammer_cli_katello/host_package'
require 'hammer_cli_katello/host_package_group'
require 'hammer_cli_katello/host_traces'
require 'hammer_cli_katello/host_bootc'

module HammerCLIKatello
  module HostExtensions
    ::HammerCLIForeman::Host::CreateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
    end
    ::HammerCLIForeman::Host::CreateCommand.extend_with(
      HammerCLIKatello::CommandExtensions::ContentSource.new,
      HammerCLIKatello::CommandExtensions::KickstartRepository.new
    )

    ::HammerCLIForeman::Host::UpdateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
    end
    ::HammerCLIForeman::Host::UpdateCommand.extend_with(
      HammerCLIKatello::CommandExtensions::ContentSource.new,
      HammerCLIKatello::CommandExtensions::KickstartRepository.new
    )

    ::HammerCLIForeman::Host::ListCommand.instance_eval do
      output do
        from :content_facet_attributes do
          field :content_view_environment_labels, _("Content View Environments"),
                                              Fields::List, :max_width => 300
          field :multi_content_view_environment,
                _("Multi Content View Environment"), Fields::Boolean
          from :errata_counts do
            field :security, _("Security"), nil, :sets => ['ALL']
            field :bugfix, _("Bugfix"), nil, :sets => ['ALL']
            field :enhancement, _("Enhancement"), nil, :sets => ['ALL']
          end
          field :bootc_booted_image, _('Running image'), nil, :sets => ['ALL']
          field :bootc_booted_digest, _('Running image digest'), nil, :sets => ['ALL']
          field :bootc_staged_image, _('Staged image'), nil, :sets => ['ALL']
          field :bootc_staged_digest, _('Staged image digest'), nil, :sets => ['ALL']
          field :bootc_available_image, _('Available image'), nil, :sets => ['ALL']
          field :bootc_available_digest, _('Available image digest'), nil, :sets => ['ALL']
          field :bootc_rollback_image, _('Rollback image'), nil, :sets => ['ALL']
          field :bootc_rollback_digest, _('Rollback image digest'), nil, :sets => ['ALL']
        end
        field :traces_status_label, _('Trace Status')
      end
    end

    ::HammerCLIForeman::Host::InfoCommand.instance_eval do
      output do
        label _('Content Information') do
          from :content_facet_attributes do
            field :content_view_environment_labels,
                  _("Content View Environment Labels"), Fields::Field
            collection :content_view_environments, _('Content View Environments') do
              from :content_view do
                label _("Content view") do
                  field :id, _("Id")
                  field :name, _("Name")
                  field :composite, _("Composite"), Fields::Boolean
                end
              end
              from :lifecycle_environment do
                label _("Lifecycle environment") do
                  field :id, _("Id")
                  field :name, _("Name")
                end
              end
              field :label, _("Label")
            end

            label _("Content Source") do
              field :content_source_id, _("Id")
              field :content_source_name, _("Name")
            end

            label _("Kickstart Repository") do
              field :kickstart_repository_id, _("Id")
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
            field :uuid, _('Uuid')
            field :last_checkin, _('Last Checkin')
            field :release_version, _('Release Version')
            field :autoheal, _('Autoheal')
            field :registered_through, _('Registered To')
            field :registered_at, _('Registered At')
            collection :activation_keys, _('Registered by Activation Keys'), :hide_blank => true do
              custom_field Fields::Reference
            end
            label _('System Purpose') do
              field :service_level, _('Service Level')
              field :purpose_usage, _('Purpose Usage')
              field :purpose_role, _('Purpose Role')
            end
          end
        end

        label _('bootc Image Information') do
          from :content_facet_attributes do
            field :bootc_booted_image, _('Running image')
            field :bootc_booted_digest, _('Running image digest')
            field :bootc_staged_image, _('Staged image')
            field :bootc_staged_digest, _('Staged image digest')
            field :bootc_available_image, _('Available image')
            field :bootc_available_digest, _('Available image digest')
            field :bootc_rollback_image, _('Rollback image')
            field :bootc_rollback_digest, _('Rollback image digest')
          end
        end

        field :traces_status_label, _('Trace Status')

        collection :host_collections, _('Host Collections') do
          field :id, _('Id')
          field :name, _('Name')
        end
      end
    end
  end
end
