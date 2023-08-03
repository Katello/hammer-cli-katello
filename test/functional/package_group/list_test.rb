require_relative '../test_helper'
require 'hammer_cli_katello/package_group'

module HammerCLIKatello
  describe PackageGroupCommand::ListCommand do
    it 'allows minimal options' do
      api_expects(:package_groups, :index)

      run_cmd(%w[package-group list])
    end

    it 'can be provided by repository ID' do
      api_expects(:package_groups, :index) do |params|
        params['repository_id'] == 1
      end

      run_cmd(%w[package-group list --repository-id 1])
    end

    it 'needs product options with repository name' do
      cmd = run_cmd(%w[package-group list --repository Repo])
      api_expects_no_call
      error_msg = "At least one of options --product, --product-id is required."
      assert_match error_msg, cmd.err
    end

    it 'can be provided product id and repository name' do
      api_expects(:repositories, :index)
        .with_params(name: "Repo", product_id: 1)
        .returns(index_response([{'id' => 1}]))

      api_expects(:package_groups, :index)
        .with_params(repository_id: 1)

      run_cmd(%w[package-group list --repository Repo --product-id 1])
    end
  end
end
