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

  Dir["#{File.dirname(__FILE__)}/hammer_cli_katello/*.rb"].each do |f|
    require f
  end

end
