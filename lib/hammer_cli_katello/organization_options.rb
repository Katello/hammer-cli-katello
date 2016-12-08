module HammerCLIKatello
  module OrganizationOptions
    def self.included(base)
      base.option '--organization-id', 'ORGANIZATION_ID',
        _('Organization ID to search by'), attribute_name: :option_organization_id
      base.option '--organization', 'ORGANIZATION_NAME',
        _('Organization name to search by'), attribute_name: :option_organization_name
      base.option '--organization-label', 'ORGANIZATION_LABEL',
        _('Organization label to search by'), attribute_name: :option_organization_label
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
