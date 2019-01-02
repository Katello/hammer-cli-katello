require File.join(File.dirname(__FILE__), '../test_helper')

require 'hammer_cli/testing/output_matchers'
require 'hammer_cli/testing/command_assertions'
require 'hammer_cli/testing/data_helpers'
require 'hammer_cli_foreman/testing/api_expectations'

include HammerCLI::Testing::OutputMatchers
include HammerCLI::Testing::CommandAssertions
include HammerCLI::Testing::DataHelpers
include HammerCLIForeman::Testing::APIExpectations

def assert_success(command_run_result)
  assert command_run_result.exit_code.zero?,
    "Nonzero exit code (#{command_run_result.exit_code}): #{command_run_result.err}"
end

def assert_failure(command_run_result, msg = nil)
  assert !command_run_result.exit_code.zero?, "Success exit code (0) when expecting failure"
  if msg
    assert command_run_result.err[msg],
      "Actual:\n#{command_run_result.err}\nExpected:\n#{msg.inspect}"
  end
end
