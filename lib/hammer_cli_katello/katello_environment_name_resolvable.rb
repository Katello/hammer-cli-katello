module HammerCLIKatello
  module KatelloEnvironmentNameResolvable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def resource_name_mapping
        mapping = Command.resource_name_mapping
        mapping[:environment] = :lifecycle_environment
        mapping
      end
    end

    class LifecycleEnvironmentParamSource
      def initialize(command)
        @command = command
      end

      def get_options(_defined_options, result)
        if result['option_environment_name'] && result['option_environment_id'].nil?
          result['option_environment_id'] = @command.resolver.lifecycle_environment_id(
              lifecycle_environment_resolve_options(result))
        end
        result
      end

      def lifecycle_environment_resolve_options(options)
        {
            HammerCLI.option_accessor_name("name") => options['option_environment_name'],
            HammerCLI.option_accessor_name("id") => options['option_environment_id'],
            HammerCLI.option_accessor_name("organization_id") => options["option_organization_id"],
            HammerCLI.option_accessor_name("organization_name") => options["option_organization_name"]
        }
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
