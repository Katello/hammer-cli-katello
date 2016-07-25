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
  end
end
