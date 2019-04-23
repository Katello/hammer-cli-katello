module HammerCLIKatello
  module CommandExtensions
    class LifecycleEnvironment < HammerCLI::CommandExtensions
      # Remove when support of --environment options is ended.
      option '--environment', 'ENVIRONMENT_NAME', _('Lifecycle environment name to search by'),
             attribute_name: :option_environment_name,
             deprecated: { '--environment' => _('Use --lifecycle-environment instead') }
      option '--environment-id', 'ENVIRONMENT_ID', _(''),
             format: HammerCLI::Options::Normalizers::Number.new,
             attribute_name: :option_environment_id,
             deprecated: { '--environment-id' => _('Use --lifecycle-environment-id instead') }

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
