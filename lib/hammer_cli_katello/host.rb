require 'hammer_cli_foreman/host'
require 'hammer_cli_katello/host_package'
require 'hammer_cli_katello/host_package_group'

module HammerCLIKatello

  HammerCLIForeman::Host.subcommand "package",
                                    HammerCLIKatello::HostPackage.desc,
                                    HammerCLIKatello::HostPackage

  HammerCLIForeman::Host.subcommand "package-group",
                                    HammerCLIKatello::HostPackageGroup.desc,
                                    HammerCLIKatello::HostPackageGroup

end
