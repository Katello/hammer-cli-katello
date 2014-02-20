require 'hammer_cli'
require 'hammer_cli_foreman'
require 'hammer_cli/exit_codes'
require 'hammer_cli_foreman/commands'
require 'hammer_cli_foreman/output/fields'

require 'katello_api'

module HammerCLIKatello

  def self.exception_handler_class
    HammerCLIForeman::ExceptionHandler
  end

  require "#{File.dirname(__FILE__)}/hammer_cli_katello/commands.rb"
  require "#{File.dirname(__FILE__)}/hammer_cli_katello/associating_commands"
  require "#{File.dirname(__FILE__)}/hammer_cli_katello/version.rb"

  Dir["#{File.dirname(__FILE__)}/hammer_cli_katello/*.rb"].each do |f|
    require f
  end

end
