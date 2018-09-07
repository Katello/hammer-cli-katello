module HammerCLIKatello
  module HostContentSourceOptions
    def self.included(base)
      base.option "--content-source", "CONTENT_SOURCE_NAME",
             _("Content Source name "),
             :attribute_name => :option_content_source
    end

    def request_params
      super.tap do |mod|
        resource_name = resource.singular_name
        if option_content_source && !option_content_source_id
          resource_hash = if resource_name == "hostgroup"
                            mod[resource_name]
                          else
                            mod[resource_name]["content_facet_attributes"]
                          end

          proxy_options = { HammerCLI.option_accessor_name('name') => option_content_source}
          resource_hash["content_source_id"] = resolver.smart_proxy_id(proxy_options)
        end
      end
    rescue HammerCLIForeman::ResolverError => e
      e.message.gsub!('smart_proxy', _('Content Source'))
      raise e
    end
  end
end
