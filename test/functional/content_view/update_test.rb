require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require 'hammer_cli_katello/content_view'

module HammerCLIKatello
  describe ContentView::UpdateCommand do
    include OrganizationHelpers
    include ContentViewHelpers

    it 'allows minimal options' do
      api_expects(:content_views, :update) do |p|
        p['id'] == 2
      end
      run_cmd(%w(content-view update --id 2))
    end

    describe 'OrganizationOptions' do
      it 'requires organization if content view name is supplied' do
        api_expects_no_call
        result = run_cmd(%w(content-view update --name cv2))
        assert(result.err[/--organization-id, --organization, --organization-label is required/],
               "Organization option requirements are validated")
      end

      it 'allows organization id' do
        expect_content_view_search('1', 'cv2', 2)
        api_expects(:content_views, :update) do |p|
          p['id'] == 2
        end
        run_cmd(%w(content-view update --name cv2 --organization-id 1))
      end

      it 'allows organization name' do
        expect_organization_search('org1', 1)
        expect_content_view_search(1, 'cv2', 2)
        api_expects(:content_views, :update) do |p|
          p['id'] == 2
        end
        run_cmd(%w(content-view update --name cv2 --organization org1))
      end

      it 'allows organization label' do
        expect_organization_search('org1', 1, field: 'label')
        expect_content_view_search(1, 'cv2', 2)
        api_expects(:content_views, :update) do |p|
          p['id'] == 2
        end
        run_cmd(%w(content-view update --name cv2 --organization-label org1))
      end

      it 'requires organization if product name is supplied along with repository' do
        id = 122
        repo_id = 100
        product_name = "foo"
        api_expects_no_call
        cmd = %W(content-view update --id=#{id}\
                 --repository-ids=#{repo_id} --product=#{product_name})
        result = run_cmd(cmd)
        expected_error = "--organization-id, --organization, --organization-label is required"
        assert(result.err.include?(expected_error),
               "Organization option requirements are validated")
      end

      it 'requires product if repository names are provided' do
        id = 122
        repo_id = 100
        organization_id = 5
        api_expects_no_call
        cmd = %W(content-view update --id=#{id}\
                 --repositories=#{repo_id} --organization-id=#{organization_id})
        result = run_cmd(cmd)
        expected_error = "--product-id, --product is required"
        assert(result.err.include?(expected_error),
               "Product option requirements are validated")
      end
    end
  end
end
