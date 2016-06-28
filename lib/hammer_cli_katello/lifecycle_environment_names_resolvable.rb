module HammerCLIKatello
  module LifecycleEnvironmentNamesResolvable
    def lifecycle_environments_resolve_options(options)
      {
        HammerCLI.option_accessor_name("names") => options['option_environment_names'],
        HammerCLI.option_accessor_name("ids") => options['options_environment_ids'],
        HammerCLI.option_accessor_name("organization_id") => options["option_organization_id"],
        HammerCLI.option_accessor_name("organization_name") => options["option_organization_name"]
      }
    end

    def all_options
      result = super.clone
      if result['option_environment_names'] && result['option_environment_ids'].nil?
        result['option_environment_ids'] =  resolver.lifecycle_environment_ids(
            lifecycle_environments_resolve_options(result))
        @all_options = result
      end
      result
    end
  end
end
