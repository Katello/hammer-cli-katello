require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::CreateCommand do
    it 'requires organization options' do
      result = run_cmd(%w[host-collection create --name hc1])
      expected_error = "Could not find organization"
      assert_equal(result.exit_code, HammerCLI::EX_SOFTWARE)
      assert_equal(result.err[/#{expected_error}/], expected_error)
    end

    it 'allows organization id' do
      api_expects(:host_collections, :create) do |par|
        par['organization_id'].to_i == 1
      end

      run_cmd(%w[host-collection create --name hc1 --organization-id 1])
    end

    it 'allows organization name' do
      api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :create) do |par|
        par['organization_id'].to_i == 1
      end

      run_cmd(%w[host-collection create --name hc1 --organization org1])
    end

    it 'allows unlimited-hosts flag with no arguments' do
      api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :create) do |par|
        par['unlimited_hosts'] == true
      end

      run_cmd(%w[host-collection create --name hc1 --organization org1 --unlimited-hosts])
    end

    it 'allows organization label' do
      api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :create) do |par|
        par['organization_id'].to_i == 1
      end

      run_cmd(%w[host-collection create --name hc1 --organization-label org1])
    end
  end
end
