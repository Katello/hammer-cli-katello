require 'hammer_cli'
require 'hammer_cli/exit_codes'
require 'hammer_cli_foreman/output/fields'

module HammerCLIKatello

  def self.exception_handler_class
    HammerCLIForeman::ExceptionHandler
  end

  Dir["#{File.dirname(__FILE__)}/hammer_cli_katello/*.rb"].each { |f| require f }

end
