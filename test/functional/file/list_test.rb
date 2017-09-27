require_relative '../test_helper.rb'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require_relative '../repository/repository_helpers'
require_relative '../product/product_helpers'
require_relative 'file_helpers'
require 'hammer_cli_katello/file'

module HammerCLIKatello
  describe FileCommand::ListCommand do
    include FileHelpers
    include ContentViewHelpers
    include RepositoryHelpers
    include ProductHelpers
    include OrganizationHelpers

    it 'allows minimal options' do
      expect_file_search({}, {})
      run_cmd(%w(file list))
    end

    describe 'requires' do
      describe 'organization options' do
        it 'to resolve product ID' do
          api_expects_no_call
          result = run_cmd(%w(file list --product product1))
          assert_match(/--organization-id/, result.err)
        end

        it 'to resolve content view ID' do
          api_expects_no_call
          result = run_cmd(%w(file list --content-view cv1))
          assert_match(/--organization-id/, result.err)
        end
      end

      describe 'product options' do
        it 'to resolve repository ID' do
          api_expects_no_call
          result = run_cmd(%w(file list --repository repo1))
          assert_match(/--product-id/, result.err)
        end
      end
    end

    describe 'allows filtering by' do
      it 'repository ID' do
        expect_file_search({'repository_id' => 2}, {})
        run_cmd(%w(file list --repository-id 2))
      end

      it 'content view version ID' do
        expect_file_search({'content_view_version_id' => 2}, {})
        run_cmd(%w(file list --content-view-version-id 2))
      end
    end

    describe 'resolves' do
      describe 'repository ID' do
        it 'from name and product ID' do
          expect_generic_repositories_search(
            {'name' => 'repo2', 'product_id' => 1}, 'id' => 2)
          expect_file_search({'repository_id' => 2}, {})
          run_cmd(%w(file list --repository repo2 --product-id 1))
        end

        it 'from name, product, and organization ID' do
          expect_generic_product_search({'name' => 'product1', 'organization_id' => 3}, 'id' => 1)
          expect_generic_repositories_search({'name' => 'repo2', 'product_id' => 1}, 'id' => 2)
          expect_file_search({'repository_id' => 2}, {})
          run_cmd(%w(file list --repository repo2 --product product1 --organization-id 3))
        end

        it 'from name, product, and organization name' do
          expect_organization_search('org3', 3)
          expect_generic_product_search({'name' => 'product1', 'organization_id' => 3}, 'id' => 1)
          expect_generic_repositories_search({'name' => 'repo2', 'product_id' => 1}, 'id' => 2)
          expect_file_search({'repository_id' => 2}, {})
          run_cmd(%w(file list --repository repo2 --product product1 --organization org3))
        end
      end

      describe 'content view version ID' do
        it 'from version and content view ID' do
          expect_content_view_version_search(
            {'version' => '1.0', 'content_view_id' => 1}, 'id' => 2)
          expect_file_search({'content_view_version_id' => 2}, {})
          run_cmd(%w(file list --content-view-version 1.0 --content-view-id 1))
        end

        it 'from version, content view name, and organization ID' do
          expect_generic_content_view_search(params: {'name' => 'cv1', 'organization_id' => 3},
                                             returns: {'id' => 1})
          expect_content_view_version_search(
            {'version' => '1.0', 'content_view_id' => 1}, 'id' => 2)
          expect_file_search({'content_view_version_id' => 2}, {})
          run_cmd(%w(file list --content-view-version 1.0 --content-view cv1 --organization-id 3))
        end

        it 'from version, content view name, and organization name' do
          expect_organization_search('org3', 3)
          expect_generic_content_view_search(params: {'name' => 'cv1', 'organization_id' => 3},
                                             returns: {'id' => 1})
          expect_content_view_version_search(
            {'version' => '1.0', 'content_view_id' => 1}, 'id' => 2)
          expect_file_search({'content_view_version_id' => 2}, {})
          run_cmd(%w(file list --content-view-version 1.0 --content-view cv1 --organization org3))
        end
      end
    end
  end
end
