require_relative '../test_helper.rb'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require_relative '../repository/repository_helpers'
require_relative '../product/product_helpers'
require_relative 'file_helpers'
require 'hammer_cli_katello/file'

# rubocop:disable ModuleLength
module HammerCLIKatello
  describe FileCommand::InfoCommand do
    include FileHelpers
    include ContentViewHelpers
    include RepositoryHelpers
    include ProductHelpers
    include OrganizationHelpers

    it 'allows minimal options' do
      expect_file_show('id' => '1')
      run_cmd(%w(file info --id 1))
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

    describe 'resolves ID from file name' do
      it 'and repository ID' do
        expect_file_search({'repository_id' => '2', search: "name = \"foo\""}, 'id' => 1)
        expect_file_show('id' => 1)
        run_cmd(%w(file info --name foo --repository-id 2))
      end

      describe 'repository name' do
        it 'and product ID' do
          expect_generic_repositories_search({'name' => 'repo2', 'product_id' => 1}, 'id' => 2)
          expect_file_search({'repository_id' => '2', search: "name = \"foo\""}, 'id' => 1)
          expect_file_show('id' => 1)
          run_cmd(%w(file info --name foo --repository repo2 --product-id 1))
        end

        describe 'product name, and organization' do
          it 'ID' do
            expect_generic_product_search({'name' => 'product1', 'organization_id' => 3}, 'id' => 1)
            expect_generic_repositories_search({'name' => 'repo2', 'product_id' => 1}, 'id' => 2)
            expect_file_search({'repository_id' => '2', search: "name = \"foo\""}, 'id' => 1)
            expect_file_show('id' => 1)
            run_cmd(%w(file info --name foo --repository repo2 --product product1
                       --organization-id 3))
          end

          it 'name' do
            expect_organization_search('org3', 3)
            expect_generic_product_search({'name' => 'product1', 'organization_id' => 3}, 'id' => 1)
            expect_generic_repositories_search({'name' => 'repo2', 'product_id' => 1}, 'id' => 2)
            expect_file_search({'repository_id' => '2', search: "name = \"foo\""}, 'id' => 1)
            expect_file_show('id' => 1)
            run_cmd(%w(file info --name foo --repository repo2 --product product1
                       --organization org3))
          end

          it 'label' do
            expect_organization_search('org3', 3, field: 'label')
            expect_generic_product_search({'name' => 'product1', 'organization_id' => 3}, 'id' => 1)
            expect_generic_repositories_search({'name' => 'repo2', 'product_id' => 1}, 'id' => 2)
            expect_file_search({'repository_id' => '2', search: "name = \"foo\""}, 'id' => 1)
            expect_file_show('id' => 1)
            run_cmd(%w(file info --name foo --repository repo2 --product product1
                       --organization-label org3))
          end
        end
      end

      it 'and content view version ID' do
        expect_file_search({'content_view_version_id' => '2', 'name' => 'foo'}, 'id' => 1)
        expect_file_show('id' => 1)
        run_cmd(%w(file info --name foo --content-view-version-id 2))
      end

      describe 'content view version' do
        it 'and content view ID' do
          expect_content_view_version_search({'version' => '2.0',
                                              'content_view_id' => 3}, 'id' => 2)
          expect_file_search({'content_view_version_id' => '2',
                              search: "name = \"foo\""}, 'id' => 1)
          expect_file_show('id' => 1)
          run_cmd(%w(file info --name foo --content-view-version 2.0 --content-view-id 3))
        end

        describe 'content view name, and organization' do
          it 'ID' do
            expect_content_view_search(4, 'cv3', 3)
            expect_content_view_version_search({'version' => '2.0',
                                                'content_view_id' => 3}, 'id' => 2)
            expect_file_search({'content_view_version_id' => '2',
                                search: "name = \"foo\""}, 'id' => 1)
            expect_file_show('id' => 1)
            run_cmd(%w(file info --name foo --content-view-version 2.0 --content-view cv3
                       --organization-id 4))
          end

          it 'name' do
            expect_organization_search('org4', 4)
            expect_content_view_search(4, 'cv3', 3)
            expect_content_view_version_search({'version' => '2.0',
                                                'content_view_id' => 3}, 'id' => 2)
            expect_file_search({'content_view_version_id' => '2',
                                search: "name = \"foo\""}, 'id' => 1)
            expect_file_show('id' => 1)
            run_cmd(%w(file info --name foo --content-view-version 2.0 --content-view cv3
                       --organization org4))
          end

          it 'label' do
            expect_organization_search('org4', 4, field: 'label')
            expect_content_view_search(4, 'cv3', 3)
            expect_content_view_version_search({'version' => '2.0',
                                                'content_view_id' => 3}, 'id' => 2)
            expect_file_search({'content_view_version_id' => '2',
                                search: "name = \"foo\""}, 'id' => 1)
            expect_file_show('id' => 1)
            run_cmd(%w(file info --name foo --content-view-version 2.0 --content-view cv3
                       --organization-label org4))
          end
        end
      end
    end
  end
end
# rubocop:enable ModuleLength
