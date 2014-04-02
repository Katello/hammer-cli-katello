module HammerCLIKatello
  module ScopedName
    def scoped_name_to_id(name, resource)
      organization = get_option_value(:organization_id)
      results = resource.call(:index, "name" => "#{name}", "organization_id" => organization)
      results = HammerCLIForeman.collection_to_common_format(results)

      msg_opt = {
        :resource => resource.name,
        :value => name
      }

      fail _("%{resource} with name '%{value}' not found") % msg_opt  if results.empty?
      fail _("%{resource} with name '%{value}' found more than once") % msg_opt if results.count > 1
      results.first['id']
    end
  end

  module ScopedNameCommand
    include HammerCLIKatello::ScopedName

    # rubocop:disable MethodLength
    def self.included(cls)
      unless cls.find_option("--id")
        cls.option("--id", "ID", _("resource id"),
                   :attribute_name => :option_id, :required => false)
      end

      unless cls.find_option("--organization-id")
        cls.option("--organization-id", "ORGANIZATION",
                   _("ID of the organization which the resource belongs to"),
                   :attribute_name => :option_organization_id, :required => false)
      end

      unless cls.find_option("--name")
        cls.option("--name", "NAME", _("resource name"),
                   :attribute_name => :option_name, :required => false)
      end
    end

    def validate_options
      id = get_option_value(:id)
      name = get_option_value(:name)
      organization_id = get_option_value(:organization_id)
      msg = _("Either --id or --organization-id and --name is required")

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
