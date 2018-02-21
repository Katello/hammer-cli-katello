module HammerCLIKatello
  module LifecycleEnvironmentNameResolvable
    class LifecycleEnvironmentParamSource
      def initialize(command)
        @command = command
      end

      def get_options(_defined_options, result)
        if result['option_environment_name'] && result['option_environment_id'].nil?
          result['option_environment_id'] = @command.resolver.lifecycle_environment_id(
            @command.resolver.scoped_options('environment', result, :single))
        end
        result
      end
    end

    def option_sources
      sources = super
      idx = sources.index { |s| s.class == HammerCLIForeman::OptionSources::IdParams }
      sources.insert(idx, LifecycleEnvironmentParamSource.new(self))
      sources
    end
  end
end
