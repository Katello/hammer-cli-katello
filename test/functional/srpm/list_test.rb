require_relative '../test_helper'
require_relative '../repository/repository_helpers'
require_relative '../product/product_helpers'
require_relative '../organization/organization_helpers'
require 'hammer_cli_katello/package'
require 'hammer_cli_katello/srpm'

module HammerCLIKatello
  describe SrpmCommand::ListCommand do
    include OrganizationHelpers
    include RepositoryHelpers
    include ProductHelpers

    it 'allows minimal options' do
      api_expects(:srpms, :index)

      run_cmd(%w[srpm list])
    end

    describe 'repository options' do
      it 'may be specified by ID' do
        api_expects(:srpms, :index).with_params('repository_id' => 1)

        run_cmd(%w[srpm list --repository-id 1])
      end

      it 'require product ID when given repository name' do
        api_expects_no_call

        r = run_cmd(%w[srpm list --repository repo1])
        assert(r.err.include?("--product-id, --product is required"), "Invalid error message")
      end

      it 'may be specified by name and product ID' do
        expect_repository_search(2, 'repo1', 1)

        api_expects(:srpms, :index).with_params('repository_id' => 1)

        run_cmd(%w[srpm list --repository repo1 --product-id 2])
      end
    end

    describe 'organization options' do
      it 'may be specified by ID' do
        api_expects(:srpms, :index).with_params('organization_id' => 1)

        run_cmd(%w[srpm list --organization-id 1])
      end

      it 'may be specified by name' do
        expect_organization_search('org3', 1)
        api_expects(:srpms, :index).with_params('organization_id' => 1)

        run_cmd(%w[srpm list --organization org3])
      end

      it 'may be specified by label' do
        expect_organization_search('org3', 1, field: 'label')
        api_expects(:srpms, :index).with_params('organization_id' => 1)

        run_cmd(%w[srpm list --organization-label org3])
      end
    end

    describe 'content-view options' do
      it 'may be specified by ID' do
        api_expects(:content_view_versions, :index)
          .with_params('content_view_id' => 1, 'version' => '2.1')
          .returns(index_response([{'id' => 5}]))
        api_expects(:srpms, :index).with_params('content_view_version_id' => 5)

        run_cmd(%w[srpm list --content-view-id 1 --content-view-version 2.1])
      end

      it 'requires organization ID when given content view name' do
        api_expects_no_call

        r = run_cmd(%w[srpm list --content-view cv1 --content-view-version 2.1])
        expected_error = "--organization-id, --organization, --organization-label is required"
        assert(r.err.include?(expected_error), "Invalid error message")
      end

      it 'requires content view ID when given content view version number' do
        api_expects_no_call

        r = run_cmd(%w[srpm list --content-view-version cvv1])
        assert(r.err.include?("--content-view-id, --content-view is required"),
               "Invalid error message")
      end
    end
  end
end
