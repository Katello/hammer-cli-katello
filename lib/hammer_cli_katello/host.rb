require 'hammer_cli_foreman/host'
require 'hammer_cli_katello/host_extensions'
require 'hammer_cli_katello/host_errata'
require 'hammer_cli_katello/host_subscription'
require 'hammer_cli_katello/host_package'
require 'hammer_cli_katello/host_deb'
require 'hammer_cli_katello/host_package_group'
require 'hammer_cli_katello/host_traces'

module HammerCLIKatello
  HammerCLIForeman::Host.subcommand "errata",
                                    HammerCLIKatello::HostErrata.desc,
                                    HammerCLIKatello::HostErrata

  HammerCLIForeman::Host.subcommand "package",
                                    HammerCLIKatello::HostPackage.desc,
                                    HammerCLIKatello::HostPackage

  HammerCLIForeman::Host.subcommand "deb-package",
                                    HammerCLIKatello::HostDebPackage.desc,
                                    HammerCLIKatello::HostDebPackage

  HammerCLIForeman::Host.subcommand "package-group",
                                    HammerCLIKatello::HostPackageGroup.desc,
                                    HammerCLIKatello::HostPackageGroup

  HammerCLIForeman::Host.subcommand "subscription",
                                    HammerCLIKatello::HostSubscription.desc,
                                    HammerCLIKatello::HostSubscription

  HammerCLIForeman::Host.subcommand "traces",
                                    HammerCLIKatello::HostTraces.desc,
                                    HammerCLIKatello::HostTraces
end
