module HammerCLIKatello
  class HostCollectionErratumCommand < HammerCLIKatello::Command
    command_name "erratum"
    desc _("Manipulate errata for a host collection")

    class InstallCommand < HammerCLIKatello::HostCollection::InstallContentBaseCommand
      desc _("Install errata on content hosts contained within a host collection")
      success_message _("Successfully scheduled installation of errata.")
      failure_message _("Could not schedule installation of errata")

      option('--errata',
        'ERRATA',
        _("List of Errata to install"),
        :required => true,
        :format => HammerCLI::Options::Normalizers::List.new,
        :attribute_name => :content)

      def content_type
        'errata'
      end
    end

    autoload_subcommands
  end
end
