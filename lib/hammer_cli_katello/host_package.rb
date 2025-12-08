module HammerCLIKatello
  class HostPackage < HammerCLIKatello::Command
    desc "Manage packages on your hosts"

    class ListCommand < HammerCLIKatello::ListCommand
      resource :host_packages, :index

      output do
        field :nvra, _("Nvra")
        field :persistence, _("Persistence"), nil, :sets => ['ALL']
      end

      build_options
    end

    class InstallCommand < HammerCLIKatello::Command
      command_name "install"

      def self.rex_feature
        "katello_package_install"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    class UpgradeCommand < HammerCLIKatello::Command
      command_name "upgrade"
      def self.rex_feature
        "katello_package_update"
      end

      include UnsupportedKatelloAgentCommandHelper
    end

    class UpgradeAllCommand < HammerCLIKatello::Command
      command_name "upgrade-all"

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

    class ContainerfileInstallCommand < HammerCLIKatello::Command
      desc _("Generate a Containerfile RUN command from transiently installed packages on image mode hosts")
      resource :host_packages, :containerfile_install_command
      command_name "containerfile-install-command"

      output do
        field :command, nil, Fields::Field, :hide_blank => true
        field :message, _("Message"), Fields::Field, :hide_blank => true
      end

      build_options
    end

    autoload_subcommands
  end
end
