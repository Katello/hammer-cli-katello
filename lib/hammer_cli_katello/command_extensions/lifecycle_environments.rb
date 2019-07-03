module HammerCLIKatello
  module CommandExtensions
    class LifecycleEnvironments < HammerCLI::CommandExtensions
      # Remove when support of --environments options is ended.
      option '--environments', 'ENVIRONMENT_NAMES', _(''),
             format: HammerCLI::Options::Normalizers::List.new,
             attribute_name: :option_environment_names,
             deprecated: { '--environments' => _('Use --lifecycle-environments instead') }
      option '--environment-ids', 'ENVIRONMENT_IDS', _(''),
             format: HammerCLI::Options::Normalizers::List.new,
             attribute_name: :option_environment_ids,
             deprecated: { '--environment-ids' => _('Use --lifecycle-environment-ids instead') }

      option_sources do |sources, command|
        sources.find_by_name('IdResolution').insert_relative(
          :after,
          'IdsParams',
          HammerCLIKatello::OptionSources::LifecycleEnvironmentParams.new(command)
        )
        sources
      end
    end
  end
end
