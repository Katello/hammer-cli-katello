require 'hammer_cli'
require 'hammer_cli/exit_codes'

module HammerCLIKatello

  def self.exception_handler_class
    HammerCLI::ExceptionHandler
  end

  # require 'hammer_cli_katello/stuff'
  # ...
  # ...
  require 'hammer_cli_katello/ping'
  require 'hammer_cli_katello/product'

end
