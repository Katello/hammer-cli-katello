module HammerCLIKatello
  module OptionSources
    class LifecycleEnvironmentParams < HammerCLI::Options::Sources::Base
      def initialize(command)
        @command = command
      end

      def get_options(_defined_options, result)
        if result['option_environment_name'] && result['option_environment_id'].nil?
          result['option_environment_id'] = @command.resolver.lifecycle_environment_id(
            @command.resolver.scoped_options('environment', result, :single))
        end
        if result['option_environment_names'] && result['option_environment_ids'].nil?
          result['option_environment_ids'] = @command.resolver.lifecycle_environment_ids(
            @command.resolver.scoped_options('environment', result, :multi))
        end
        result
      end
    end
  end
end
