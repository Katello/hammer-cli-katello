module HammerCLIKatello
  class HostCollectionPackageCommand < HammerCLIKatello::Command
    command_name "package"
    desc "Manage packages on your host collections. "\
         "These commands are no longer available. "\
         "Use the remote execution equivalent"

    class InstallCommand < HammerCLIKatello::Command
      command_name "install"
      def self.rex_feature
        "katello_package_install"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    class UpdateCommand < HammerCLIKatello::Command
      command_name "update"
      def self.rex_feature
        "katello_package_update"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    class RemoveCommand < HammerCLIKatello::Command
      command_name "remove"
      def self.rex_feature
        "katello_package_remove"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    autoload_subcommands
  end
end
