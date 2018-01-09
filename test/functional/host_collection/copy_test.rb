require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::CopyCommand do
    it 'requires a new name' do
      result = run_cmd(%w(host-collection copy --id 1))
      expected_error = "option '--new-name' is required"
      assert_equal(result.exit_code, HammerCLI::EX_USAGE)
      assert_equal(result.err[/#{expected_error}/], expected_error)
    end

    it 'does not require organization options if id is specified' do
      api_expects(:host_collections, :copy)
      run_cmd(%w(host-collection copy --id 1 --new-name foo))
    end

    it 'requires organization options if name is specified' do
      result = run_cmd(%w(host-collection copy --name hc1 --new-name foo))
      expected_error = "Missing options to search organization"
      assert_equal(HammerCLI::EX_SOFTWARE, result.exit_code)
      assert_equal(expected_error, result.err[/#{expected_error}/])
    end

    it 'allows organization id' do
      api_expects(:host_collections, :index) { |par| par['organization_id'].to_i == 1 }
        .returns(index_response([{'id' => 2}]))

      api_expects(:host_collections, :copy) do |par|
        par['id'].to_i == 2
      end

      run_cmd(%w(host-collection copy --name hc1 --organization-id 1 --new-name foo))
    end

    it 'allows organization name' do
      api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :index) { |par| par['organization_id'].to_i == 1 }
        .returns(index_response([{'id' => 2}]))

      api_expects(:host_collections, :copy) do |par|
        par['id'].to_i == 2
      end

      run_cmd(%w(host-collection copy --name hc1 --organization org1 --new-name foo))
    end

    it 'allows organization label' do
      api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:host_collections, :index) { |par| par['organization_id'].to_i == 1 }
        .returns(index_response([{'id' => 2}]))

      api_expects(:host_collections, :copy) do |par|
        par['id'].to_i == 2
      end

      run_cmd(%w(host-collection copy --name hc1 --organization-label org1 --new-name foo))
    end
  end
end
