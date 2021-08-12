module HammerCLIKatello
  module CommandExtensions
    class ContentSource < HammerCLI::CommandExtensions
      option_family associate: 'content_source' do
        child '--content-source', 'CONTENT_SOURCE_NAME', _('Content Source name'),
              attribute_name: :option_content_source,
              referenced_resource: :smart_proxy
      end

      request_params do |params, cmd_obj|
        begin
          resource_name = cmd_obj.resource.singular_name
          if cmd_obj.option_content_source && !cmd_obj.option_content_source_id
            resource_hash = if resource_name == 'hostgroup'
                              params[resource_name]
                            else
                              params[resource_name]['content_facet_attributes']
                            end

            proxy_options = {
              HammerCLI.option_accessor_name('name') => cmd_obj.option_content_source
            }
            resource_hash['content_source_id'] = cmd_obj.resolver.smart_proxy_id(proxy_options)
          end
        rescue HammerCLIForeman::ResolverError => e
          e.message.gsub!('smart_proxy', _('Content Source'))
          raise e
        end
      end
    end
  end
end
