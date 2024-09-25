require_relative '../test_helper'
require 'hammer_cli_katello/associating_commands'
require 'json'

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
    json_data = JSON.parse(File.read(json_file))
    ex.returns(json_data)

    expected_fields = json_data.map do |key, value|
      [key.split('_').map(&:capitalize).join(' '), value.nil? ? '' : value.to_s]
    end

    result = run_cmd(@cmd + params)

    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected| assert_cmd(expected, result) }
  end
end