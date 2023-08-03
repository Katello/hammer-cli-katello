require File.join(File.dirname(__FILE__), '../test_helper')
require 'hammer_cli/testing/messages'

include HammerCLI::Testing::Messages # rubocop:disable Style/MixinUsage
describe "message formatting" do
  check_all_command_messages(HammerCLI::MainCommand, HammerCLIKatello::Command)
end
