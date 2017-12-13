require_relative '../test_helper'
require 'hammer_cli_foreman/hostgroup'

module HammerCLIForeman
  describe Hostgroup do
    describe InfoCommand do
      before do
        @cmd = %w(hostgroup info)
      end

      let(:hostgroup_id) { 1 }

      it "Shows information about a hostgroup" do
        params = ["--id=#{hostgroup_id}"]

        ex = api_expects(:hostgroups, :show, "Get info") do |par|
          par["id"] == hostgroup_id.to_s
        end
        json_file = File.join(File.dirname(__FILE__), 'data', 'hostgroup.json')
        ex.returns(JSON.parse(File.read(json_file)))

        result = run_cmd(@cmd + params)
        # rubocop:disable Style/WordArray
        expected_fields = [['Name', 'Library'],
                           ['Name', 'Default Organization View'],
                           ['Name', 'foreman.example.com'],
                           ['Name', 'Rhel 7']]
        expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
        expected_results.each { |expected|  assert_cmd(expected, result) }
      end
    end
  end
end
