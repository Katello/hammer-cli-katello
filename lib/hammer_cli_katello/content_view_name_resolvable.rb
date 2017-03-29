module HammerCLIKatello
  module ContentViewNameResolvable
    def content_view_resolve_options(options)
      {
        HammerCLI.option_accessor_name("name") => options['option_content_view_name'],
        HammerCLI.option_accessor_name("organization_id") => options["option_organization_id"],
        HammerCLI.option_accessor_name("organization_name") => options["option_organization_name"]
      }
    end

    def all_options
      if super['option_content_view_name'] && super['option_content_view_id'].nil?
        super['option_content_view_id'] = resolver.content_view_id(
          content_view_resolve_options(super))
      end
      super
    end
  end
end
