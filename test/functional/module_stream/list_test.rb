require_relative '../test_helper'
require 'hammer_cli_katello/module_stream'

module HammerCLIKatello
  describe ModuleStreamCommand::ListCommand do
    it 'allows minimal options' do
      api_expects(:module_streams, :index)

      run_cmd(%w(module-stream list))
    end

    it 'can be provided by repository ID' do
      api_expects(:module_streams, :index).with_params(repository_id: 1)

      run_cmd(%w(module-stream list --repository-id 1))
    end

    it 'product params needed with repository name' do
      cmd = run_cmd(%w(module-stream list --repository Repo))
      error_msg = "At least one of options --product, --product-id is required."
      api_expects_no_call
      assert_match error_msg, cmd.err
    end

    it 'can be provided by repository name and product id' do
      api_expects(:repositories, :index)
        .with_params(name: "Repo", product_id: 1)
        .returns(index_response([{'id' => 1}]))

      api_expects(:module_streams, :index).with_params(repository_id: 1)

      run_cmd(%w(module-stream list --repository Repo --product-id 1))
    end

    it 'can be provided by repository id and organization id' do
      api_expects(:module_streams, :index)
        .with_params(repository_id: 1, organization_id: 1)

      run_cmd(%w(module-stream list --repository-id 1 --organization-id 1))
    end

    it 'can be provided by repository name, product id, and organization id' do
      api_expects(:repositories, :index)
        .with_params(name: "Repo", product_id: 1)
        .returns(index_response([{'id' => 1}]))

      api_expects(:module_streams, :index)
        .with_params(repository_id: 1, organization_id: 1)

      run_cmd(%w(module-stream list --repository Repo --product-id 1 --organization-id 1))
    end
  end
end
