require_relative '../test_helper'
require_relative '../repository/repository_helpers'
require_relative '../product/product_helpers'
require_relative '../organization/organization_helpers'
require_relative '../lifecycle_environment/lifecycle_environment_helpers'
require 'hammer_cli_katello/package'

module HammerCLIKatello
  describe PackageCommand::ListCommand do
    include OrganizationHelpers
    include LifecycleEnvironmentHelpers
    include RepositoryHelpers
    include ProductHelpers

    it 'allows minimal options' do
      api_expects(:packages, :index)

      run_cmd(%w(package list))
    end

    describe 'content view options' do
      it 'may be specified by ID' do
        api_expects(:content_view_versions, :index)
          .with_params('content_view_id' => 1, 'version' => '2.1')
          .returns(index_response([{'id' => 5}]))
        api_expects(:packages, :index)
          .with_params('content_view_version_id' => 5)
          .returns(index_response([{'id' => 1}, {'id' => 2}]))

        run_cmd(%w(package list --content-view-id 1 --content-view-version 2.1))
      end

      it 'requires organization ID when given content view name' do
        api_expects_no_call

        r = run_cmd(%w(package list --content-view cv1 --content-view-version 2.1))
        expected_error = "--organization-id, --organization, --organization-label is required"
        assert(r.err.include?(expected_error), "Invalid error message")
      end

      it 'requires content view ID when given content view version name' do
        api_expects_no_call

        r = run_cmd(%w(package list --content-view-version cvv1))
        assert(r.err.include?("--content-view-id, --content-view is required"),
               "Invalid error message")
      end
    end

    describe 'repository options' do
      it 'may be specified by ID' do
        api_expects(:packages, :index).with_params('repository_id' => 1)

        run_cmd(%w(package list --repository-id 1))
      end

      it 'require product ID when given repository name' do
        api_expects_no_call

        r = run_cmd(%w(package list --repository repo1))
        assert(r.err.include?("--product-id, --product is required"), "Invalid error message")
      end

      it 'may be specified by name and product ID' do
        expect_repository_search(2, 'repo1', 1)

        api_expects(:packages, :index).with_params('repository_id' => 1)

        run_cmd(%w(package list --repository repo1 --product-id 2))
      end
    end

    describe 'environment options' do
      it 'may be specified environment name' do
        org_id = 2
        env_name = "dev"
        expected_id = 6
        expect_lifecycle_environment_search(org_id, env_name, expected_id)

        api_expects(:packages, :index).with_params("organization_id" => org_id,
                                                   "environment_id" => expected_id,
                                                   "page" => 1, "per_page" => 1000)

        run_cmd(%W(package list --environment=#{env_name} --organization-id=#{org_id}))
      end

      it 'may be specified environment name no org fails' do
        api_expects_no_call
        r = run_cmd(%w(package list --environment Library))
        expec_err = "Missing options to search organization"
        puts r.err
        assert(r.err.include?(expec_err), "Invalid error message")
      end
    end

    describe 'product options' do
      it 'may be specified by ID' do
        api_expects(:repositories, :index)
          .with_params('product_id' => 1)
          .returns(index_response([{'id' => 2}]))

        api_expects(:packages, :index).with_params('repository_id' => 2)

        run_cmd(%w(package list --product-id 1))
      end

      it 'fail if more than one repository is found' do
        api_expects(:repositories, :index)
          .with_params('product_id' => 1)
          .returns(index_response([{'id' => 2}, {'id' => 3}]))

        r = run_cmd(%w(package list --product-id 1))
        assert(r.err.include?("Found more than one repository"), "Invalid error message: #{r.err}")
      end

      it 'requires organization options to resolve ID by name' do
        api_expects_no_call

        r = run_cmd(%w(package list --product product1))
        expected_error = "--organization-id, --organization, --organization-label is required"
        assert(r.err.include?(expected_error), "Invalid error message")
      end

      it 'allows organization ID when resolving ID by name' do
        expect_product_search(3, 'product1', 1)

        expect_generic_repositories_search({'product_id' => 1}, [{'id' => 2}])

        api_expects(:packages, :index).with_params('repository_id' => 2)

        run_cmd(%w(package list --product product1 --organization-id 3))
      end

      it 'allows organization name when resolving ID by name' do
        expect_organization_search('org3', 3)

        expect_product_search(3, 'product1', 1)

        expect_generic_repositories_search({'product_id' => 1}, [{'id' => 2}])

        api_expects(:packages, :index).with_params('repository_id' => 2)

        run_cmd(%w(package list --product product1 --organization org3))
      end

      it 'allows organization label when resolving ID by name' do
        expect_organization_search('org3', 3, field: 'label')

        expect_product_search(3, 'product1', 1)

        expect_generic_repositories_search({'product_id' => 1}, [{'id' => 2}])

        api_expects(:packages, :index).with_params('repository_id' => 2)

        run_cmd(%w(package list --product product1 --organization-label org3))
      end
    end
  end
end
