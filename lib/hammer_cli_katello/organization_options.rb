module HammerCLIKatello
  module OrganizationOptions
    def self.included(base)
      base.option_family do
        parent '--organization-id', 'ORGANIZATION_ID',
               _('Organization ID to search by'), attribute_name: :option_organization_id
        child '--organization', 'ORGANIZATION_NAME',
              _('Organization name to search by'), attribute_name: :option_organization_name
        child '--organization-label', 'ORGANIZATION_LABEL',
              _('Organization label to search by'), attribute_name: :option_organization_label
      end
    end

    def org_options
      {
        HammerCLI.option_accessor_name("organization_id") => options["option_organization_id"],
        HammerCLI.option_accessor_name("organization_name") => options["option_organization_name"],
        HammerCLI.option_accessor_name("organization_label") => options["option_organization_label"]
      }
    end
  end
end
