require 'hammer_cli_foreman/hostgroup'
require 'hammer_cli_katello/host_kickstart_repository_options'
require 'hammer_cli_katello/host_content_source_options'

module HammerCLIKatello
  module QueryOrganizationOptions
    def self.included(base)
      base.option '--query-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by'), attribute_name: :option_organization_id
      base.option '--query-organization', 'ORGANIZATION_NAME',
        _('Organization name to search by'), attribute_name: :option_organization_name
      base.option '--query-organization-label', 'ORGANIZATION_LABEL',
        _('Organization label to search by'), attribute_name: :option_organization_label

      base.validate_options :before, 'IdResolution' do
        organization_options = [
          :option_organization_id, :option_organization_name, :option_organization_label
        ]

        if option(:option_lifecycle_environment_name).exist? ||
           option(:option_content_view_name).exist?
          any(*organization_options).required
        end
      end
    end
  end

  module HostgroupExtensions
    ::HammerCLIForeman::Hostgroup::CreateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      include HammerCLIKatello::ContentViewNameResolvable
      include HammerCLIKatello::QueryOrganizationOptions
      include HammerCLIKatello::HostContentSourceOptions
      include HammerCLIKatello::HostKickstartRepositoryOptions
    end

    ::HammerCLIForeman::Hostgroup::UpdateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      include HammerCLIKatello::ContentViewNameResolvable
      include HammerCLIKatello::QueryOrganizationOptions
      include HammerCLIKatello::HostContentSourceOptions
      include HammerCLIKatello::HostKickstartRepositoryOptions
    end

    ::HammerCLIForeman::Hostgroup::InfoCommand.instance_eval do
      output do
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
      end
    end
  end
end
