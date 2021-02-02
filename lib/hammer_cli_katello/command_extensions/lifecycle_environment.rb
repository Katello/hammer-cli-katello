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
