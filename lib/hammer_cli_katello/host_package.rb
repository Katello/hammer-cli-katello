module HammerCLIKatello
  class HostPackage < HammerCLIKatello::Command
    desc "Manage packages on your hosts"

    class ListCommand < HammerCLIKatello::ListCommand
      resource :host_packages, :index

      output do
        field :nvra, _("Nvra")
      end

      build_options
    end

    class InstallCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_packages, :install
      command_name "install"
      success_message "Packages install successfully."
      failure_message "Could not install packages"

      validate_options do
        option(:option_packages).required
      end

      build_options :without => [:groups]

      def execute
        warn "This command uses katello agent and will be removed in favor of remote execution " \
          "in Katello 4.10."
        warn "The remote execution equivalent is `hammer job-invocation create --feature " \
          "katello_package_install`."
        super
      end
    end

    class UpgradeCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_packages, :upgrade
      command_name "upgrade"
      success_message "Packages upgraded successfully."
      failure_message "Could not upgrade packages"

      build_options

      def execute
        warn "This command uses katello agent and will be removed in favor of remote execution " \
          "in Katello 4.10."
        warn "The remote execution equivalent is `hammer job-invocation create --feature " \
          "katello_package_update`."
        super
      end
    end

    class UpgradeAllCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_packages, :upgrade_all
      command_name "upgrade-all"
      success_message "All packages upgraded successfully."
      failure_message "Could not upgrade all packages"

      build_options

      def execute
        warn "This command uses katello agent and will be removed in favor of remote execution " \
          "in Katello 4.10."
        warn "The remote execution equivalent is `hammer job-invocation create --feature " \
          "katello_package_update`."
        super
      end
    end

    class RemoveCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_packages, :remove
      command_name "remove"
      success_message "Packages removed successfully."
      failure_message "Could not remove packages"

      validate_options do
        option(:option_packages).required
      end

      build_options :without => [:groups]

      def execute
        warn "This command uses katello agent and will be removed in favor of remote execution " \
          "in Katello 4.10."
        warn "The remote execution equivalent is `hammer job-invocation create --feature " \
          "katello_package_remove`."
        super
      end
    end

    autoload_subcommands
  end
end
