module HammerCLIKatello


  module ScopedNameCommand

    # rubocop: disable MethodLength
    def self.included(cls)

      cls.option "--id", "ID", _("The id"),
                 :attribute_name => :option_id,
                 :required => false

      cls.option "--organization-id", "ORGANIZATION_ID",
                 _("The ID of the organization which the resource belongs to"),
                 :attribute_name => :option_organization_id,
                 :required => false

      cls.option "--organization", "ORGANIZATION",
                 _("The ID of the organization which the resource belongs to"),
                 :attribute_name => :option_organization_name,
                 :required => false

      cls.option "--name", "NAME", _("The name of the resource"),
                 :attribute_name => :option_name,
                 :required => false
    end

    def validate_options
      unless validator.option(:option_id).exist?
        validator.option(:option_name).required :msg => _("Either --id or --name is required")
        validator.any(:option_organization_id, :option_organization_name)
          .required(:msg => _("Either --organization or --organization-id is required"))
      end
      super
    end

  end
end
