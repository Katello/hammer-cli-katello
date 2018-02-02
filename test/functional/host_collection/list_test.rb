require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::ListCommand do
    it 'does not require organization options' do
      api_expects(:host_collections, :index)

      run_cmd(%w(host-collection list))
    end

    it 'allows organization id' do
      api_expects(:host_collections, :index) do |par|
        par['organization_id'].to_i == 1
      end

      run_cmd(%w(host-collection list --organization-id 1))
    end

    it 'allows organization name' do
      api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :index) do |par|
        par['organization_id'].to_i == 1
      end

      run_cmd(%w(host-collection list --organization org1))
    end

    it 'allows organization label' do
      api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :index) do |par|
        par['organization_id'].to_i == 1
      end

      run_cmd(%w(host-collection list --organization-label org1))
    end

    it 'allows host id' do
      api_expects(:host_collections, :index) do |par|
        par['host_id'] == 1
      end

      run_cmd(%w(host-collection list --host-id 1 --organization-id 1))
    end

    it 'allows host name' do
      ex = api_expects(:hosts, :index) do |par|
        par[:search] == "name = \"host1\""
      end
      ex.returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :index) do |par|
        par['host_id'] == 1
      end

      run_cmd(%w(host-collection list --host host1 --organization-id 1))
    end
  end
end
