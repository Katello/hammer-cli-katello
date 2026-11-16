require_relative 'test_helper'
require 'hammer_cli_katello/host'
require 'hammer_cli_katello/host_collection'

# Hammer uses Minitest assertions, including refute_match.
# rubocop:disable Rails/RefuteMethods
module HammerCLIKatello
  describe 'Package-group execution command removal' do
    actions = %w[install update remove]
    option_sets = [[], ['--help']]
    %w[host host-collection].each do |parent|
      it "omits package-group from #{parent} help while keeping package commands" do
        api_expects_no_call
        result = run_cmd([parent, '--help'])

        assert_success(result)
        refute_match(/^\s+package-group(?:\s|$)/, result.out)
        assert_match(/^\s+package(?:\s|$)/, result.out)
      end

      actions.each do |action|
        option_sets.each do |options|
          command = [parent, 'package-group', action] + options
          it "rejects #{command.join(' ')} as an unknown command" do
            api_expects_no_call
            result = run_cmd(command)

            assert_exit_code_equal(HammerCLI::EX_USAGE, result.exit_code)
            refute_match(/katello_group_(install|update|remove)/, result.out + result.err)
          end
        end
      end
    end

    it 'keeps the top-level package-group content commands' do
      api_expects_no_call
      result = run_cmd(%w[package-group --help])

      assert_success(result)
      assert_match(/^\s+list(?:\s|$)/, result.out)
      assert_match(/^\s+info(?:\s|$)/, result.out)
    end
  end
end
# rubocop:enable Rails/RefuteMethods
