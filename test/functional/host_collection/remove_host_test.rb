require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::RemoveHostCommand do
    it 'does not require organization options if id is specified' do
      api_expects(:host_collections, :remove_hosts)
      run_cmd(%w(host-collection remove-host --id 1))
    end

    it 'requires organization options if name is specified' do
      result = run_cmd(%w(host-collection remove-host --name hc1))
      expected_error = "Could not find organization"
      assert_equal(result.exit_code, HammerCLI::EX_SOFTWARE)
      assert_equal(result.err[/#{expected_error}/], expected_error)
    end

    it 'allows organization id' do
      api_expects(:host_collections, :index) { |par| par['organization_id'].to_i == 1 }
        .returns(index_response([{'id' => 2}]))

      api_expects(:host_collections, :remove_hosts) do |par|
        par['id'].to_i == 2
      end

      run_cmd(%w(host-collection remove-host --name hc1 --organization-id 1))
    end

    it 'allows organization name' do
      api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :index) { |par| par['organization_id'].to_i == 1 }
        .returns(index_response([{'id' => 2}]))

      api_expects(:host_collections, :remove_hosts) do |par|
        par['id'].to_i == 2
      end

      run_cmd(%w(host-collection remove-host --name hc1 --organization org1))
    end

    it 'allows organization label' do
      api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :index) { |par| par['organization_id'].to_i == 1 }
        .returns(index_response([{'id' => 2}]))

      api_expects(:host_collections, :remove_hosts) do |par|
        par['id'].to_i == 2
      end

      run_cmd(%w(host-collection remove-host --name hc1 --organization-label org1))
    end
  end
end
