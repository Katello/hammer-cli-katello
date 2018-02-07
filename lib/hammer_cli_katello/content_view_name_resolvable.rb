module HammerCLIKatello
  module ContentViewNameResolvable
    class ContentViewParamSource
      def initialize(command)
        @command = command
      end

      def get_options(_defined_options, result)
        if result['option_content_view_name'] && result['option_content_view_id'].nil?
          result['option_content_view_id'] = @command.resolver.content_view_id(
              content_view_resolve_options(result))
        end
        result
      end

      def content_view_resolve_options(options)
        {
          HammerCLI.option_accessor_name("name") => options['option_content_view_name'],
          HammerCLI.option_accessor_name("organization_id") => options["option_organization_id"],
          HammerCLI.option_accessor_name("organization_name") => options["option_organization_name"]
        }
      end
    end

    def option_sources
      sources = super
      idx = sources.index { |s| s.class == HammerCLIForeman::OptionSources::IdParams }
      sources.insert(idx, ContentViewParamSource.new(self))
      sources
    end
  end
end
