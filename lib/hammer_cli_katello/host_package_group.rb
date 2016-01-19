module HammerCLIKatello

  class HostPackageGroup < HammerCLIKatello::Command

    desc "Manage package-groups on your hosts"

    class InstallCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_packages, :install
      command_name "install"
      success_message "Package-groups installed successfully"
      failure_message "Could not install package-groups"

      validate_options do
        option(:option_groups).required
      end

      build_options :without => [:packages]
    end

    class RemoveCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_packages, :remove
      command_name "remove"
      success_message "Package-groups removed successfully"
      failure_message "Could not remove package-groups"

      validate_options do
        option(:option_groups).required
      end

      build_options :without => [:packages]
    end

    autoload_subcommands
  end

end
