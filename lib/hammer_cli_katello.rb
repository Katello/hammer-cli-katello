require 'hammer_cli'
require 'hammer_cli/exit_codes'

require 'hammer_cli_foreman/output/fields'

module HammerCLIKatello

  def self.exception_handler_class
    HammerCLIForeman::ExceptionHandler
  end

  require 'hammer_cli_katello/ping'
  require 'hammer_cli_katello/system_group'

end
