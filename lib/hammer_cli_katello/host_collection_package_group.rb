module HammerCLIKatello
  class HostCollectionPackageGroupCommand < HammerCLIKatello::Command
    command_name "package-group"
    desc "Manage package-groups on your host collections. "\
          "These commands are no longer available. "\
          "Use the remote execution equivalent"

    class InstallCommand < HammerCLIKatello::Command
      command_name "install"
      def self.rex_feature
        "katello_group_install"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    class UpdateCommand < HammerCLIKatello::Command
      command_name "update"
      def self.rex_feature
        "katello_group_update"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    class RemoveCommand < HammerCLIKatello::Command
      command_name "remove"
      def self.rex_feature
        "katello_group_remove"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    autoload_subcommands
  end
end
