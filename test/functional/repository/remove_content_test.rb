require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require 'hammer_cli_katello/repository'

module HammerCLIKatello
  describe Repository::RemoveContentCommand do
    include OrganizationHelpers

    it 'allows minimal options' do
      api_expects(:repositories, :remove_content) do |p|
        p['id'] == '1' && p['ids'] == %w(20 21 22)
      end

      run_cmd(%w(repository remove-content --id 1 --ids 20,21,22))
    end

    describe 'resolves repository ID' do
      it 'by requiring product' do
        api_expects_no_call
        result = run_cmd(%w(repository remove-content --name repo1 --ids 20,21,22))
        assert(result.err[/--product, --product-id is required/], 'Incorrect error message')
      end

      it 'by product ID' do
        ex = api_expects(:repositories, :index) do |p|
          p['name'] == 'repo1' && p['product_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :remove_content) do |p|
          p['id'] == 1 && p['ids'] == %w(20 21 22)
        end

        run_cmd(%w(repository remove-content --name repo1 --product-id 3 --ids 20,21,22))
      end
    end

    describe 'resolves product ID' do
      it 'by requiring organization options' do
        api_expects_no_call
        result = run_cmd(%w(repository remove-content --name repo1 --product prod1 --ids 20,21,22))
        assert(result.err[/--organization-id, --organization, --organization-label is required/],
               "Organization option requirements must be validated")
      end

      it 'by organization ID' do
        ex = api_expects(:products, :index) do |p|
          p['name'] == 'prod3' && p['organization_id'] == '5'
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:repositories, :index) do |p|
          p['name'] == 'repo1' && p['product_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :remove_content) do |p|
          p['id'] == 1 && p['ids'] == %w(20 21 22)
        end

        run_cmd(%w(repository remove-content --name repo1 --product prod3 --organization-id 5
                   --ids 20,21,22))
      end

      it 'by organization name' do
        expect_organization_search('org5', 5)

        ex = api_expects(:products, :index) do |p|
          p['name'] == 'prod3' && p['organization_id'] == 5
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:repositories, :index) do |p|
          p['name'] == 'repo1' && p['product_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :remove_content) do |p|
          p['id'] == 1 && p['ids'] == %w(20 21 22)
        end

        run_cmd(%w(repository remove-content --name repo1 --product prod3 --organization org5
                   --ids 20,21,22))
      end

      it 'by organization label' do
        expect_organization_search('org5', 5, field: 'label')

        ex = api_expects(:products, :index) do |p|
          p['name'] == 'prod3' && p['organization_id'] == 5
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:repositories, :index) do |p|
          p['name'] == 'repo1' && p['product_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:repositories, :remove_content) do |p|
          p['id'] == 1 && p['ids'] == %w(20 21 22)
        end

        run_cmd(%w(repository remove-content --name repo1 --product prod3 --organization-label org5
                   --ids 20,21,22))
      end
    end

    it 'does not resolves repository id without product details' do
      api_expects_no_call
      result = run_cmd(%w(repository remove-content --ids 1 --name repo1))
      assert_includes(result.err, 'At least one of options --product, --product-id is required')
    end

    it 'does not resolves repository id without organization details' do
      api_expects_no_call
      result = run_cmd(%w(repository remove-content --ids 1 --name repo1 --product product1))
      assert_includes <<STR, result.err
Could not remove content:
  Error: At least one of options --organization-id, --organization, --organization-label is required
  \n  See: 'hammer repository remove-content --help'
STR
    end
  end
end
