module HammerCLIKatello
  module LifecycleEnvironmentNameMapping
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def resource_name_mapping
        mapping = Command.resource_name_mapping
        mapping[:environment] = :lifecycle_environment
        mapping[:environments] = :lifecycle_environments
        mapping
      end

      def resource_alias_name_mapping
        HammerCLIKatello::RESOURCE_ALIAS_NAME_MAPPING
      end
    end
  end
end
