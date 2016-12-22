require 'hammer_cli_foreman/hostgroup'

module HammerCLIKatello
  module PuppetEnvironmentNameResolvable
    def all_options
      options = super
      if options['option_environment_name']
        options['option_environment_id'] ||= resolver.puppet_environment_id(
          resolver.scoped_options('environment', options))
      end
      options
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
    end

    ::HammerCLIForeman::Hostgroup::UpdateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      include HammerCLIKatello::PuppetEnvironmentNameResolvable
      include HammerCLIKatello::ContentViewNameResolvable
      include HammerCLIKatello::QueryOrganizationOptions
    end

    ::HammerCLIForeman::Hostgroup::InfoCommand.instance_eval do
      output do
        field :content_view_name, _('Content View')
        field :lifecycle_environment_name, _('Lifecycle Environment')
      end
    end
  end
end
