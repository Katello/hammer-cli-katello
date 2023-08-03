require_relative '../test_helper'
require 'hammer_cli_katello/repository'

module HammerCLIKatello
  describe Repository::DeleteCommand do
    it 'allows minimal parameters' do
      api_expects(:repositories, :destroy) { |p| p['id'] == 1 }
      run_cmd(%w[repository delete --id 1])
    end

    describe 'product options' do
      it 'are required to resolve repository name' do
        api_expects_no_call
        result = run_cmd(%w[repository delete --name repo1])
        assert_includes(result.err, 'At least one of options --product, --product-id is required')
      end

      it 'can be specified via product id' do
        api_expects(:repositories, :index)
          .with_params('product_id' => 3, 'name' => 'repo1')
          .returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

        run_cmd(%w[repository delete --name repo1 --product-id 3])
      end

      it 'can be specified via product name' do
        api_expects(:products, :index)
          .with_params('organization_id' => '6', 'name' => 'product3')
          .returns(index_response([{'id' => 3}]))

        api_expects(:repositories, :index)
          .with_params('product_id' => 3, 'name' => 'repo1')
          .returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

        run_cmd(%w[repository delete --name repo1 --product product3 --organization-id 6])
      end

      describe 'organization options' do
        it 'can be specified by organization id' do
          api_expects(:products, :index)
            .with_params('organization_id' => '6', 'name' => 'product3')
            .returns(index_response([{'id' => 3}]))

          api_expects(:repositories, :index)
            .with_params('product_id' => 3, 'name' => 'repo1')
            .returns(index_response([{'id' => 1}]))

          api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

          run_cmd(%w[repository delete --name repo1 --product product3 --organization-id 6])
        end

        it 'can be specified by organization name' do
          api_expects(:organizations, :index)
            .with_params(:search => "name = \"org6\"")
            .returns(index_response([{'id' => 6}]))

          api_expects(:products, :index)
            .with_params('organization_id' => 6, 'name' => 'product3')
            .returns(index_response([{'id' => 3}]))

          api_expects(:repositories, :index)
            .with_params('product_id' => 3, 'name' => 'repo1')
            .returns(index_response([{'id' => 1}]))

          api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

          run_cmd(%w[repository delete --name repo1 --product product3 --organization org6])
        end

        it 'can be specified by organization label' do
          api_expects(:organizations, :index)
            .with_params(:search => "label = \"org6\"")
            .returns(index_response([{'id' => 6}]))

          api_expects(:products, :index)
            .with_params('organization_id' => 6, 'name' => 'product3')
            .returns(index_response([{'id' => 3}]))

          api_expects(:repositories, :index)
            .with_params('product_id' => 3, 'name' => 'repo1')
            .returns(index_response([{'id' => 1}]))

          api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

          run_cmd(%w[repository delete --name repo1 --product product3 --organization-label org6])
        end
      end
    end
  end
end
