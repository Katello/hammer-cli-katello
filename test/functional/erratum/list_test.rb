require_relative '../test_helper'
require 'hammer_cli_katello/erratum'

module HammerCLIKatello
  describe ErratumCommand::ListCommand do
    it 'allows minimal options' do
      api_expects(:errata, :index)

      run_cmd(%w(erratum list))
    end

    describe 'product options' do
      it 'may be specified by ID' do
        ex = api_expects(:repositories, :index) do |p|
          p['product_id'] == 1
        end
        ex.returns(index_response([{'id' => 2}]))

        api_expects(:errata, :index) do |p|
          p['repository_id'] = 2
        end

        run_cmd(%w(erratum list --product-id 1))
      end

      it 'fail if more than one repository is found' do
        ex = api_expects(:repositories, :index) do |p|
          p['product_id'] == 1
        end
        ex.returns(index_response([{'id' => 2}, {'id' => 3}]))

        r = run_cmd(%w(erratum list --product-id 1))
        assert r.err.include?("Found more than one repository."), r.err
      end

      it 'requires organization options to resolve ID by name' do
        api_expects_no_call

        r = run_cmd(%w(erratum list --product product1))
        assert r.err.include? "--organization-id, --organization, --organization-label is required"
      end

      it 'allows organization ID when resolving ID by name' do
        ex = api_expects(:products, :index) do |p|
          p['name'] == 'product1' && p['organization_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        ex = api_expects(:repositories, :index) do |p|
          p['product_id'] == 1
        end
        ex.returns(index_response([{'id' => 2}]))

        api_expects(:errata, :index) do |p|
          p['repository_id'] = 2
        end

        run_cmd(%w(erratum list --product product1 --organization-id 3))
      end

      it 'allows organization name when resolving ID by name' do
        ex = api_expects(:organizations, :index) do |p|
          p[:search] == "name = \"org3\""
        end
        ex.at_least_once.returns(index_response([{'id' => 3}]))

        ex = api_expects(:products, :index) do |p|
          p['name'] == 'product1' && p['organization_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        ex = api_expects(:repositories, :index) do |p|
          p['product_id'] == 1
        end
        ex.returns(index_response([{'id' => 2}]))

        api_expects(:errata, :index) do |p|
          p['repository_id'] = 2
        end

        run_cmd(%w(erratum list --product product1 --organization org3))
      end

      it 'allows organization label when resolving ID by name' do
        ex = api_expects(:organizations, :index) do |p|
          p[:search] == "label = \"org3\""
        end
        ex.at_least_once.returns(index_response([{'id' => 3}]))

        ex = api_expects(:products, :index) do |p|
          p['name'] == 'product1' && p['organization_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        ex = api_expects(:repositories, :index) do |p|
          p['product_id'] == 1
        end
        ex.returns(index_response([{'id' => 2}]))

        api_expects(:errata, :index) do |p|
          p['repository_id'] = 2
        end

        run_cmd(%w(erratum list --product product1 --organization-label org3))
      end
    end
  end
end
