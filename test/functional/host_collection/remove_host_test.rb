require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::RemoveHostCommand do
    describe 'handles individual host errors' do
      it 'for successful results' do
        api_expects(:host_collections, :remove_hosts)
          .with_params('id' => 1, 'host_ids' => %w[2 3])
          .returns("displayMessages" => {"success" => ["Successfully removed 2 Host(s)."],
                                         "error" => []})
        result = run_cmd(%w[host-collection remove-host --id 1 --host-ids 2,3])
        assert_match("The host(s) has been removed", result.out)
      end

      it 'for mixed results' do
        api_expects(:host_collections, :remove_hosts)
          .with_params('id' => 1, 'host_ids' => %w[2 3])
          .returns("displayMessages" => {"success" => ["Successfully removed 1 Host(s)."],
                                         "error" => ["Host with ID 3 not found."]})
        result = run_cmd(%w[host-collection remove-host --id 1 --host-ids 2,3])
        assert_match("Could not remove host(s)", result.out)
        assert_match("Host with ID 3 not found.", result.out)
      end

      it 'for errored results' do
        api_expects(:host_collections, :remove_hosts)
          .with_params('id' => 1, 'host_ids' => %w[2 3])
          .returns("displayMessages" => {"success" => [], "error" => [
            "Host with ID 1 does not exist in the host collection.",
            "Host with ID 3 not found."]})
        result = run_cmd(%w[host-collection remove-host --id 1 --host-ids 2,3])
        assert_match("Could not remove host(s)", result.out)
        assert_match("Host with ID 1 does not exist in the host collection.", result.out)
        assert_match("Host with ID 3 not found.", result.out)
      end
    end

    it 'does not require organization options if id is specified' do
      api_expects(:host_collections, :remove_hosts)
      run_cmd(%w[host-collection remove-host --id 1])
    end

    it 'requires organization options if name is specified' do
      result = run_cmd(%w[host-collection remove-host --name hc1])
      expected_error = "Missing options to search organization"
      assert_equal(HammerCLI::EX_SOFTWARE, result.exit_code)
      assert_equal(expected_error, result.err[/#{expected_error}/])
    end

    it 'allows organization id' do
      api_expects(:host_collections, :index) { |par| par['organization_id'].to_i == 1 }
        .returns(index_response([{'id' => 2}]))

      api_expects(:host_collections, :remove_hosts) do |par|
        par['id'].to_i == 2
      end

      run_cmd(%w[host-collection remove-host --name hc1 --organization-id 1])
    end

    it 'allows organization name' do
      api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :index) { |par| par['organization_id'].to_i == 1 }
        .returns(index_response([{'id' => 2}]))

      api_expects(:host_collections, :remove_hosts) do |par|
        par['id'].to_i == 2
      end

      run_cmd(%w[host-collection remove-host --name hc1 --organization org1])
    end

    it 'allows organization label' do
      api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :index) { |par| par['organization_id'].to_i == 1 }
        .returns(index_response([{'id' => 2}]))

      api_expects(:host_collections, :remove_hosts) do |par|
        par['id'].to_i == 2
      end

      run_cmd(%w[host-collection remove-host --name hc1 --organization-label org1])
    end
  end
end
