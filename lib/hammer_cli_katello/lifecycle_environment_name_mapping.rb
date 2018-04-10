module HammerCLIKatello
  module LifecycleEnvironmentNameMapping
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
  end
end
