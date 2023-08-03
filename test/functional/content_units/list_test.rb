require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require_relative '../repository/repository_helpers'
require_relative '../product/product_helpers'
require 'hammer_cli_katello/content_units'

module HammerCLIKatello
  describe ContentUnitsCommand::ListCommand do
    include ContentViewHelpers
    include RepositoryHelpers
    include ProductHelpers
    include OrganizationHelpers

    it 'allows minimal options' do
      api_expects(:generic_content_units, :index)
        .with_params('content_type' => 'python_package')

      run_cmd(%w[content-units list --content-type python_package])
    end

    it 'requires content_type param' do
      api_expects_no_call

      r = run_cmd(%w[content-units list])
      assert(r.err.include?("Missing arguments for '--content-type'"), "Invalid error message")
    end

    describe 'repository options' do
      it 'may be specified by ID' do
        api_expects(:generic_content_units, :index)
          .with_params('content_type' => 'python_package', 'repository_id' => 1)

        run_cmd(%w[content-units list --content-type python_package --repository-id 1])
      end

      it 'require product ID when given repository name' do
        api_expects_no_call

        r = run_cmd(%w[content-units list --content-type python_package --repository repo1])
        assert(r.err.include?("--product, --product-id is required"), "Invalid error message")
      end

      it 'may be specified by name and product ID' do
        expect_repository_search(2, 'repo1', 1)

        api_expects(:generic_content_units, :index)
          .with_params('content_type' => 'python_package', 'repository_id' => 1)
        run_cmd(%w[content-units list --content-type python_package --repository repo1 --product-id 2])
      end
    end

    describe 'organization options' do
      it 'may be specified by ID' do
        api_expects(:generic_content_units, :index)
          .with_params('organization_id' => 1, 'content_type' => 'python_package')

        run_cmd(%w[content-units list --organization-id 1 --content-type python_package])
      end

      it 'may be specified by name' do
        expect_organization_search('org3', 1)
        api_expects(:generic_content_units, :index)
          .with_params('organization_id' => 1, 'content_type' => 'python_package')

        run_cmd(%w[content-units list --organization org3 --content-type python_package])
      end

      it 'may be specified by label' do
        expect_organization_search('org3', 1, field: 'label')
        api_expects(:generic_content_units, :index)
          .with_params('organization_id' => 1, 'content_type' => 'python_package')

        run_cmd(%w[content-units list --organization-label org3 --content-type python_package])
      end
    end

    describe 'content-view options' do
      it 'may be specified by ID' do
        api_expects(:content_view_versions, :index)
          .with_params('content_view_id' => 1, 'version' => '2.1')
          .returns(index_response([{'id' => 5}]))
        api_expects(:generic_content_units, :index)
          .with_params('content_view_version_id' => 5, 'content_type' => 'python_package')

        run_cmd(
          %w[
            content-units list --content-view-id 1 --content-view-version 2.1 --content-type python_package
          ]
        )
      end

      it 'requires organization ID when given content view name' do
        api_expects_no_call

        r = run_cmd(%w[content-units list --content-view cv1 --content-view-version 2.1 --content-type python_package])
        expected_error = "--organization-id, --organization, --organization-label is required"
        assert(r.err.include?(expected_error), "Invalid error message")
      end
    end
  end
end
