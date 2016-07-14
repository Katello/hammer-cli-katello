require 'hammer_cli_foreman/hostgroup'

module HammerCLIKatello
  module HostgroupExtensions
    ::HammerCLIForeman::Hostgroup::CreateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      option '--content-view-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by')
      option '--lifecycle-environment-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by')

      validate_options do
        if option(:option_lifecycle_environment_name).exist?
          option(:option_lifecycle_environment_organization_id).required
        end

        if option(:option_content_view_name).exist?
          option(:option_content_view_organization_id).required
        end
      end
    end

    ::HammerCLIForeman::Hostgroup::UpdateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      option '--content-view-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by')
      option '--lifecycle-environment-organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by')

      validate_options do
        if option(:option_lifecycle_environment_name).exist?
          option(:option_lifecycle_environment_organization_id).required
        end

        if option(:option_content_view_name).exist?
          option(:option_content_view_organization_id).required
        end
      end
    end
  end
end
