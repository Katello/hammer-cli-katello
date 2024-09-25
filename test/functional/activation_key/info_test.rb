require_relative '../test_helper'
require 'hammer_cli_katello/associating_commands'

describe 'activation-key info' do
  before do
    @cmd = %w(activation-key info)
  end

  it "includes katello attributes" do
    params = ['--id=1']
    ex = api_expects(:activation_keys, :show, "Activation key") do |par|
      par['id'] == 1
    end

    json_file = File.join(File.dirname(__FILE__), 'data', 'activation_key.json')
    ex.returns(JSON.parse(File.read(json_file)))

    result = run_cmd(@cmd + params)

    expected_fields = [['Name', 'test key2'],
                       ['Id', '1'],
                       ['Description', 'Activation key'],
                       ['Purpose Usage', 'Usage'],
                       ['Purpose Role', 'Role'],
                       ['Purpose Addons', 'Test Addon1, Test Addon2'],
                       ['Multi Content View Environment', 'yes'],
                       ['Organization', ''],
                       ['Id', '1'],
                       ['Name', 'Default Organization'],
                       ['Content View Environments', ''],
                       ['Content View', ''],
                       ['Id', '2'],
                       ['Name', 'RHEL-8'],
                       ['Version', '1.0'],
                       ['Content View version Id', '4'],
                       ['Composite', 'no'],
                       ['Lifecycle environment', ''],
                       ['Id', '1'],
                       ['Name', 'Library'],
                       ['Label', 'Library/RHEL-8'],
                       ['Content View', ''],
                       ['Id', '4'],
                       ['Name', 'Zoo'],
                       ['Version', '1.0'],
                       ['Content View version Id', '2'],
                       ['Composite', 'no'],
                       ['Lifecycle environment', ''],
                       ['Id', '2'],
                       ['Name', 'Dev'],
                       ['Label', 'Dev/Zoo']]

    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected|  assert_cmd(expected, result) }
  end
end
