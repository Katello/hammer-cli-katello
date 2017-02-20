require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require 'hammer_cli_katello/repository'

module HammerCLIKatello
  describe Repository::ExportCommand do
    include ForemanTaskHelpers
    include OrganizationHelpers

    it 'allows minimal options' do
      ex = api_expects(:repositories, :export) do |p|
        p['id'] == '1'
      end
      ex.returns(id: 2)

      expect_foreman_task('2')

      run_cmd(%w(repository export --id 1))
    end

    describe 'resolves repository ID' do
      it 'by requiring product' do
        api_expects_no_call
        result = run_cmd(%w(repository export --name repo1))
        assert(result.err[/--product, --product-id is required/], 'Incorrect error message')
      end

      it 'by product ID' do
        ex = api_expects(:repositories, :index) do |p|
          p['name'] == 'repo1' && p['product_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        ex = api_expects(:repositories, :export) do |p|
          p['id'] == 1
        end
        ex.returns(id: 2)

        expect_foreman_task('2')

        run_cmd(%w(repository export --name repo1 --product-id 3))
      end
    end

    describe 'resolves product ID' do
      it 'by requiring organization options' do
        api_expects_no_call
        result = run_cmd(%w(repository export --name repo1 --product prod1))
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

        ex = api_expects(:repositories, :export) do |p|
          p['id'] == 1
        end
        ex.returns(id: 2)

        expect_foreman_task('2')

        run_cmd(%w(repository export --name repo1 --product prod3 --organization-id 5))
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

        ex = api_expects(:repositories, :export) do |p|
          p['id'] == 1
        end
        ex.returns(id: 2)

        expect_foreman_task('2')

        run_cmd(%w(repository export --name repo1 --product prod3 --organization org5))
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

        ex = api_expects(:repositories, :export) do |p|
          p['id'] == 1
        end
        ex.returns(id: 2)

        expect_foreman_task('2')

        run_cmd(%w(repository export --name repo1 --product prod3 --organization-label org5))
      end
    end
  end
end
