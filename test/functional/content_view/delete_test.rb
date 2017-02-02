require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require 'hammer_cli_katello/content_view'

module HammerCLIKatello
  describe ContentView::DeleteCommand do
    include OrganizationHelpers
    include ContentViewHelpers
    include ForemanTaskHelpers

    it 'allows minimal options' do
      ex = api_expects(:content_views, :destroy) do |p|
        p['id'] == 2
      end
      ex.returns(id: '8')
      expect_foreman_task('8')
      run_cmd(%w(content-view delete --id 2))
    end

    describe 'OrganizationOptions' do
      it 'requires organization if content view name is supplied' do
        api_expects_no_call
        result = run_cmd(%w(content-view delete --name cv2))
        assert(result.err[/--organization-id, --organization, --organization-label is required/],
               "Organization option requirements are validated")
      end

      it 'allows organization id' do
        expect_content_view_search('1', 'cv2', 2)
        ex = api_expects(:content_views, :destroy) do |p|
          p['id'] == 2
        end
        ex.returns(id: '8')
        expect_foreman_task('8')
        run_cmd(%w(content-view delete --name cv2 --organization-id 1))
      end

      it 'allows organization name' do
        expect_organization_search('org1', 1)
        expect_content_view_search(1, 'cv2', 2)
        ex = api_expects(:content_views, :destroy) do |p|
          p['id'] == 2
        end
        ex.returns(id: '8')
        expect_foreman_task('8')
        run_cmd(%w(content-view delete --name cv2 --organization org1))
      end

      it 'allows organization label' do
        expect_organization_search('org1', 1, field: 'label')
        expect_content_view_search(1, 'cv2', 2)
        ex = api_expects(:content_views, :destroy) do |p|
          p['id'] == 2
        end
        ex.returns(id: '8')
        expect_foreman_task('8')
        run_cmd(%w(content-view delete --name cv2 --organization-label org1))
      end
    end
  end
end
