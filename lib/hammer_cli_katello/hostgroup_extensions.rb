require 'hammer_cli_foreman/hostgroup'
require 'hammer_cli_katello/lifecycle_environment_name_resolvable'
require 'hammer_cli_katello/content_view_name_resolvable'

module HammerCLIKatello
  module HostgroupExtensions
    ::HammerCLIForeman::Hostgroup::CreateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      include HammerCLIKatello::LifecycleEnvironmentNameResolvable
      include HammerCLIKatello::ContentViewNameResolvable
    end

    ::HammerCLIForeman::Hostgroup::UpdateCommand.instance_eval do
      include HammerCLIKatello::ResolverCommons
      include HammerCLIKatello::LifecycleEnvironmentNameResolvable
      include HammerCLIKatello::ContentViewNameResolvable
    end
  end
end
