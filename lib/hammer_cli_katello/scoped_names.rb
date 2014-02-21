module HammerCLIKatello
  module ScopedName
    def scoped_name_to_id(name, resource)
      organization = get_option_value(:organization_id)
      results = resource.call(:index, "name" => "#{name}", "organization_id" => organization).first
      results = HammerCLIForeman.collection_to_common_format(results)
      fail "#{resource.name} with name '#{name}' not found" if results.empty?
      fail "#{resource.name} with name '#{name}' found more than once" if results.count > 1
      results.first['id']
    end
  end

  module ScopedNameCommand
    include HammerCLIKatello::ScopedName

    def self.included(cls)

      cls.option "--id", "ID", "The id",
                 :attribute_name => :option_id,
                 :required => false

      cls.option "--organization-id", "ORGANIZATION",
                 "The ID of the organization which the resource belongs to",
                 :attribute_name => :option_organization_id,
                 :required => false

      cls.option "--name", "NAME", "The name of the resource",
                 :attribute_name => :option_name,
                 :required => false
    end

    def validate_options
      id = get_option_value(:id)
      name = get_option_value(:name)
      organization_id = get_option_value(:organization_id)
      msg = "Either --id or --organization-id and --name is required"

      name_and_org = (!organization_id.nil? && !name.nil?)

      if (!id.nil? && name_and_org) ||
         (id.nil? && !name_and_org)
        signal_usage_error(msg)
      end
    end

    def execute
      unless get_option_value(:id)
        self.option_id = scoped_name_to_id(get_option_value(:name), resource)
      end
      super
    end
  end
end
