module HammerCLIKatello
  module CommandExtensions
    class LifecycleEnvironment < HammerCLI::CommandExtensions
      # Remove when support of --environment options is ended.
      option_family(
        deprecated: { '--environment' => _("Use %s instead") % '--lifecycle-environment',
                      '--environment-id' => _("Use %s instead") % '--lifecycle-environment-id'}
      ) do
        child '--environment', 'ENVIRONMENT_NAME', _('Lifecycle environment name to search by'),
              attribute_name: :option_environment_name
        parent '--environment-id', 'ENVIRONMENT_ID', _(''),
               format: HammerCLI::Options::Normalizers::Number.new,
               attribute_name: :option_environment_id
      end

      # Add explicitly defined options since option builder won't be
      # able to create options automatically in case there is missing resource
      # in API docs or if the resource name is different
      # (e.g. environment instead of lifecycle_environment)
      # This can happen if API docs contain a param which cannot be mapped
      # via param_name to resource_name mapping
      option_family associate: 'lifecycle_environment' do
        child '--lifecycle-environment', 'ENVIRONMENT_NAME',
              _('Lifecycle environment name to search by'),
              attribute_name: :option_environment_name
      end

      option_sources do |sources, command|
        sources.find_by_name('IdResolution').insert_relative(
          :after,
          'IdParams',
          HammerCLIKatello::OptionSources::LifecycleEnvironmentParams.new(command)
        )
        sources
      end
    end
  end
end
