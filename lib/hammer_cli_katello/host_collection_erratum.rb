module HammerCLIKatello
  class HostCollectionErratumCommand < HammerCLIKatello::Command
    command_name "erratum"
    desc "Manage errata on your host collections. "\
         "These commands are no longer available. "\
         "Use the remote execution equivalent"

    class InstallCommand < HammerCLIKatello::Command
      command_name "install"
      def self.rex_feature
        "katello_errata_install"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    autoload_subcommands
  end
end
