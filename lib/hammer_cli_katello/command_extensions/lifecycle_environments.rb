module HammerCLIKatello
  module CommandExtensions
    class LifecycleEnvironments < HammerCLI::CommandExtensions
      # Remove when support of --environments options is ended.
      option_family(
        format: HammerCLI::Options::Normalizers::List.new,
        deprecation: _("Use %s instead") % '--lifecycle-environment[s|-ids]',
        deprecated: { '--environments' => _("Use %s instead") % '--lifecycle-environments',
                      '--environment-ids' => _("Use %s instead") % '--lifecycle-environment-ids'}
      ) do
        parent '--environment-ids', 'ENVIRONMENT_IDS', _(''),
               attribute_name: :option_environment_ids
        child '--environments', 'ENVIRONMENT_NAMES', _(''),
              attribute_name: :option_environment_names
      end

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
