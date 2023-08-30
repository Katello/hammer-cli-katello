module HammerCLIKatello
  class HostPackageGroup < HammerCLIKatello::Command
    desc "Manage package-groups on your hosts. These commands are no longer available"\
          "\n Use the remote execution equivalent"

    class InstallCommand < HammerCLIKatello::SingleResourceCommand
      command_name "install"
      def self.rex_feature
        "katello_group_install"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    class RemoveCommand < HammerCLIKatello::SingleResourceCommand
      command_name "remove"
      def self.rex_feature
        "katello_group_remove"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    autoload_subcommands
  end
end
