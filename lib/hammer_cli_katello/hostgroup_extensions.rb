require 'hammer_cli_foreman/hostgroup'

module HammerCLIKatello
  module QueryOrganizationOptions
    def self.included(base)
      base.option_family do
        parent '--query-organization-id', 'ORGANIZATION_ID',
               _('Organization ID to search by'),
               attribute_name: :option_organization_id
        child '--query-organization', 'ORGANIZATION_NAME',
              _('Organization name to search by'),
              attribute_name: :option_organization_name
        child '--query-organization-label', 'ORGANIZATION_LABEL',
              _('Organization label to search by'),
              attribute_name: :option_organization_label
      end

      base.validate_options :before, 'IdResolution' do
        organization_options = %i[
          option_organization_id option_organization_name option_organization_label
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
    end
    ::HammerCLIForeman::Hostgroup::CreateCommand.extend_with(
      HammerCLIKatello::CommandExtensions::ContentSource.new,
      HammerCLIKatello::CommandExtensions::KickstartRepository.new
    )

    ::HammerCLIForeman::Hostgroup::UpdateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      include HammerCLIKatello::ContentViewNameResolvable
      include HammerCLIKatello::QueryOrganizationOptions
    end
    ::HammerCLIForeman::Hostgroup::UpdateCommand.extend_with(
      HammerCLIKatello::CommandExtensions::ContentSource.new,
      HammerCLIKatello::CommandExtensions::KickstartRepository.new
    )

    ::HammerCLIForeman::Hostgroup::InfoCommand.instance_eval do
      output do
        label _("Content View") do
          field :content_view_id, _("Id")
          field :content_view_name, _("Name")
        end

        label _("Lifecycle Environment") do
          field :lifecycle_environment_id, _("Id")
          field :lifecycle_environment_name, _("Name")
        end

        label _("Content Source") do
          field :content_source_id, _("Id")
          field :content_source_name, _("Name")
        end

        label _("Kickstart Repository") do
          field :kickstart_repository_id, _("Id")
          field :kickstart_repository_name, _("Name")
        end
      end
    end
  end
end
