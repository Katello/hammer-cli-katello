module HammerCLIKatello
  module ContentViewNameResolvable
    class ContentViewParamSource < HammerCLI::Options::Sources::Base
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
      sources.find_by_name('IdResolution').insert_relative(
        :after,
        'IdParams',
        ContentViewParamSource.new(self)
      )
      sources
    end
  end
end
