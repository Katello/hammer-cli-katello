require_relative '../test_helper'
require 'hammer_cli_katello/repository'

module HammerCLIKatello
  describe Repository::DeleteCommand do
    it 'allows minimal parameters' do
      api_expects(:repositories, :destroy) { |p| p['id'] == '1' }
      run_cmd(%w(repository delete --id 1))
    end

    describe 'product options' do
      it 'are required to resolve repository name' do
        api_expects_no_call
        result = run_cmd(%w(repository delete --name repo1))
        assert_includes(result.err, 'At least one of options --product, --product-id is required')
      end

      it 'can be specified via product id' do
        ex = api_expects(:repositories, :index) do |p|
          p['product_id'] == 3 && p['name'] == 'repo1'
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

        run_cmd(%w(repository delete --name repo1 --product-id 3))
      end

      it 'can be specified via product name' do
        ex = api_expects(:products, :index) do |p|
          p['organization_id'] == '6' && p['name'] == 'product3'
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:repositories, :index) do |p|
          p['product_id'] == 3 && p['name'] == 'repo1' && p['organization_id'] == '6'
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

        run_cmd(%w(repository delete --name repo1 --product product3 --organization-id 6))
      end

      describe 'organization options' do
        it 'can be specified by organization id' do
          ex = api_expects(:repositories, :index) do |p|
            p['product_id'] == 3 && p['name'] == 'repo1' && p['organization_id'] == '6'
          end
          ex.returns(index_response([{'id' => 1}]))

          api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

          run_cmd(%w(repository delete --name repo1 --product-id 3 --organization-id 6))
        end

        it 'can be specified by organization name' do
          ex = api_expects(:organizations, :index) do |p|
            p[:search] == "name = \"org6\""
          end
          ex.returns(index_response([{'id' => 6}]))

          ex = api_expects(:products, :index) do |p|
            p['organization_id'] == 6 && p['name'] == 'product3'
          end
          ex.returns(index_response([{'id' => 3}]))

          ex = api_expects(:repositories, :index) do |p|
            p['product_id'] == 3 && p['name'] == 'repo1'
          end
          ex.returns(index_response([{'id' => 1}]))

          api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

          run_cmd(%w(repository delete --name repo1 --product product3 --organization org6))
        end

        it 'can be specified by organization label' do
          ex = api_expects(:organizations, :index) do |p|
            p[:search] == "label = \"org6\""
          end
          ex.returns(index_response([{'id' => 6}]))

          ex = api_expects(:products, :index) do |p|
            p['organization_id'] == 6 && p['name'] == 'product3'
          end
          ex.returns(index_response([{'id' => 3}]))

          ex = api_expects(:repositories, :index) do |p|
            p['product_id'] == 3 && p['name'] == 'repo1'
          end
          ex.returns(index_response([{'id' => 1}]))

          api_expects(:repositories, :destroy) { |p| p['id'] == 1 }

          run_cmd(%w(repository delete --name repo1 --product product3 --organization-label org6))
        end
      end
    end
  end
end
