require_relative '../test_helper'
require 'hammer_cli_katello/module_stream'

module HammerCLIKatello
  describe ModuleStreamCommand::InfoCommand do
    it 'allows ID' do
      api_expects(:module_streams, :show).with_params('id' => '1')

      run_cmd(%w[module-stream info --id 1])
    end

    it 'resolves ID from name and repo id' do
      api_expects(:module_streams, :index)
        .with_params(search: "name = \"duck\"", name: "duck", repository_id: "1")
        .returns(index_response([{'id' => "1"}]))

      api_expects(:module_streams, :show)
        .with_params(repository_id: 1, id: "1")

      run_cmd(%w[module-stream info --name duck --repository-id 1])
    end

    it 'resolves ID from name, repo name, and product id' do
      api_expects(:module_streams, :index)
        .with_params(search: "name = \"walrus\"")
        .returns(index_response([{'id' => 1}]))

      api_expects(:repositories, :index)
        .with_params(name: 'zoo', product_id: 1)
        .returns(index_response([{'id' => 1}]))

      api_expects(:module_streams, :show)
        .with_params(repository_id: 1, id: 1)

      run_cmd(%w[module-stream info --name walrus --repository zoo --product-id 1])
    end

    it 'resolves ID from name, repo name, product name, and org id' do
      api_expects(:products, :index)
        .with_params(name: "habitat", organization_id: 1)
        .returns(index_response([{'id' => 1}]))

      api_expects(:module_streams, :index)
        .with_params(search: "name = \"walrus\"")
        .returns(index_response([{'id' => 1}]))

      api_expects(:repositories, :index)
        .with_params(name: 'zoo', product_id: 1)
        .returns(index_response([{'id' => 1}]))

      api_expects(:module_streams, :show)
        .with_params(repository_id: 1, id: 1)

      run_cmd(%w[module-stream info --name walrus --repository zoo
                 --product habitat --organization-id 1])
    end
  end
end
