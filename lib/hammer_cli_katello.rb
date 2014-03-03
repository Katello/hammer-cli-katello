require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli/exit_codes'
require 'hammer_cli_foreman/commands'
require 'hammer_cli_foreman/output/fields'
require 'hammer_cli_foreman_tasks'

require 'katello_api'

module HammerCLIKatello

  def self.exception_handler_class
    HammerCLIKatello::ExceptionHandler
  end

  require "#{File.dirname(__FILE__)}/hammer_cli_katello/commands.rb"
  require "#{File.dirname(__FILE__)}/hammer_cli_katello/associating_commands"
  require "#{File.dirname(__FILE__)}/hammer_cli_katello/version.rb"

  require "hammer_cli_katello/commands"
  require "hammer_cli_katello/scoped_names"

  require "hammer_cli_katello/activation_key"
  require "hammer_cli_katello/gpg_key"
  require "hammer_cli_katello/lifecycle_environment"
  require "hammer_cli_katello/organization"
  require "hammer_cli_katello/ping"
  require "hammer_cli_katello/product"
  require "hammer_cli_katello/provider"
  require "hammer_cli_katello/repository_set"
  require "hammer_cli_katello/subscription"
  require "hammer_cli_katello/system_group"
  require "hammer_cli_katello/system"
  require "hammer_cli_katello/version"

end
