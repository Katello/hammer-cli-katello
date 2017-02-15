require_relative '../test_helper'
require 'hammer_cli_katello/package_group'

module HammerCLIKatello
  describe PackageGroupCommand::ListCommand do
    it 'allows minimal options' do
      api_expects(:package_groups, :index)

      run_cmd(%w(package-group list))
    end

    it 'can be provided by repository ID' do
      api_expects(:package_groups, :index) do |params|
        params['repository_id'] == 1
      end

      run_cmd(%w(package-group list --repository-id 1))
    end

    it 'can be provided by repository name' do
      ex = api_expects(:repositories, :index) do |params|
        params['name'] = 'Repo'
      end
      ex.returns(index_response([{'id' => 1}]))

      api_expects(:package_groups, :index) do |params|
        params['repository_id'] == 1
      end

      run_cmd(%w(package-group list --repository Repo))
    end
  end
end
