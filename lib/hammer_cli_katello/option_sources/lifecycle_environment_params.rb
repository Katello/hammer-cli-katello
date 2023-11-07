module HammerCLIKatello
  module OptionSources
    class LifecycleEnvironmentParams < HammerCLI::Options::Sources::Base
      def initialize(command)
        @command = command
      end

      def get_options(_defined_options, result)
        legacy_option_id(result)
        legacy_option_ids(result)
        ensure_option_id(result)
        ensure_option_ids(result)
        result
      end

      private

      def lifecycle_environment_resource_name
        (HammerCLIForeman.param_to_resource('environment') ||
          HammerCLIForeman.param_to_resource('lifecycle_environment')).singular_name
      end

      def legacy_option_id(result)
        if result['option_environment_name'] && result['option_environment_id'].nil?
          result['option_environment_id'] = @command.resolver.lifecycle_environment_id(
            @command.resolver.scoped_options(lifecycle_environment_resource_name, result, :single))
        end
        if result['option_lifecycle_environment_id'] && result['option_environment_id'].nil?
          result['option_environment_id'] = result['option_lifecycle_environment_id']
        end
      end

      def legacy_option_ids(result)
        if result['option_environment_names'] && result['option_environment_ids'].nil?
          result['option_environment_ids'] = @command.resolver.lifecycle_environment_ids(
            @command.resolver.scoped_options(lifecycle_environment_resource_name, result, :multi))
        end
        if result['option_lifecycle_environment_ids'] && result['option_environment_ids'].nil?
          result['option_environment_ids'] = result['option_lifecycle_environment_ids']
        end
      end

      def ensure_option_id(result)
        if result['option_environment_id'].nil? && result['option_lifecycle_environment_name']
          id = @command.resolver.lifecycle_environment_id(
            @command.resolver.scoped_options(lifecycle_environment_resource_name, result, :single)
          )
          result['option_environment_id'] = id
          result['option_lifecycle_environment_id'] = id
        end
      end

      def ensure_option_ids(result)
        if result['option_environment_ids'].nil? && result['option_lifecycle_environment_names']
          ids = @command.resolver.lifecycle_environment_ids(
            @command.resolver.scoped_options(lifecycle_environment_resource_name, result, :multi)
          )
          result['option_environment_ids'] = ids
          result['option_lifecycle_environment_ids'] = ids
        end
      end
    end
  end
end
