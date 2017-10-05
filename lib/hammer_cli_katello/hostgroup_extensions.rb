require 'hammer_cli_foreman/hostgroup'
require 'hammer_cli_katello/host_kickstart_repository_options'
require 'hammer_cli_katello/host_content_source_options'

module HammerCLIKatello
  module PuppetEnvironmentNameResolvable
    def all_options
      if super['option_environment_name']
        super['option_environment_id'] ||= resolver.puppet_environment_id(
          resolver.scoped_options('environment', super))
      end
      super
    end
  end

  module QueryOrganizationOptions
    def self.included(base)
      base.option '--query-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by'), attribute_name: :option_organization_id
      base.option '--query-organization', 'ORGANIZATION_NAME',
        _('Organization name to search by'), attribute_name: :option_organization_name
      base.option '--query-organization-label', 'ORGANIZATION_LABEL',
        _('Organization label to search by'), attribute_name: :option_organization_label

      base.validate_options do
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
      include HammerCLIKatello::PuppetEnvironmentNameResolvable
      include HammerCLIKatello::ContentViewNameResolvable
      include HammerCLIKatello::QueryOrganizationOptions
      include HammerCLIKatello::HostContentSourceOptions
      include HammerCLIKatello::HostKickstartRepositoryOptions
    end

    ::HammerCLIForeman::Hostgroup::UpdateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      include HammerCLIKatello::PuppetEnvironmentNameResolvable
      include HammerCLIKatello::ContentViewNameResolvable
      include HammerCLIKatello::QueryOrganizationOptions
      include HammerCLIKatello::HostContentSourceOptions
      include HammerCLIKatello::HostKickstartRepositoryOptions
    end

    ::HammerCLIForeman::Hostgroup::InfoCommand.instance_eval do
      output do
        field :content_view_name, _('Content View')
        field :lifecycle_environment_name, _('Lifecycle Environment')
        field :content_source_name, _('Content Source')
        field :kickstart_repository_name, _('Repository')
      end
    end
  end
end
