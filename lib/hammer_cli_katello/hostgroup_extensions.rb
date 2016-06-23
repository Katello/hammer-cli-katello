require 'hammer_cli_foreman/hostgroup'

module HammerCLIKatello
  module HostgroupExtensions
    ::HammerCLIForeman::Hostgroup::CreateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      option '--content-view-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by')
      option '--lifecycle-environment-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by')
    end

    ::HammerCLIForeman::Hostgroup::UpdateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      option '--content-view-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by')
      option '--lifecycle-environment-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by')
    end
  end
end
