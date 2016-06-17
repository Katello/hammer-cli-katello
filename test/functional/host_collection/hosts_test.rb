require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::HostsCommand do
    it 'allows host collection id' do
      api_expects(:hosts, :index) do |par|
        par['search'] == "host_collection_id=1"
      end

      run_cmd(%w(host-collection hosts --id 1))
    end

    it 'allows host collection name' do
      ex = api_expects(:host_collections, :index)
      ex.returns(index_response([{'id' => 2}]))

      api_expects(:hosts, :index) do |par|
        par['search'] == "host_collection_id=2"
      end

      run_cmd(%w(host-collection hosts --name collection --organization-id 1))
    end

    it 'requires organization with host collection name' do
      result = run_cmd(%w(host-collection hosts --name collection))
      expected_error = "Error: Could not find organization, please set one of options " \
                       "--organization, --organization-label, --organization-id."
      assert_equal(HammerCLI::EX_SOFTWARE, result.exit_code)
      assert_equal(expected_error, result.err[/#{expected_error}/])
    end

    it 'requires host collection name or id' do
      result = run_cmd(%w(host-collection hosts))
      expected_error = "Error: At least one of options --id, --name is required"
      assert_equal(HammerCLI::EX_USAGE, result.exit_code)
      assert_equal(expected_error, result.err[/#{expected_error}/])
    end
  end
end
