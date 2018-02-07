module HammerCLIKatello
  module ContentViewNameResolvable
    class ContentViewParamSource
      def initialize(command)
        @command = command
      end

      def get_options(_defined_options, result)
        if result['option_content_view_name'] && result['option_content_view_id'].nil?
          result['option_content_view_id'] = @command.resolver.content_view_id(
              @command.resolver.scoped_options('content_view', result, :single))
        end
        result
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
