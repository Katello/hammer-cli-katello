require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require 'hammer_cli_katello/content_view'

module HammerCLIKatello
  describe ContentView::CopyCommand do
    include OrganizationHelpers
    include ContentViewHelpers

    it 'allows minimal options' do
      api_expects(:content_views, :copy) do |p|
        p['id'] == 2 && p['name'] == 'cv2-dup'
      end
      run_cmd(%w[content-view copy --id 2 --new-name cv2-dup])
    end

    describe 'OrganizationOptions' do
      it 'requires organization if content view name is supplied' do
        api_expects_no_call
        result = run_cmd(%w[content-view copy --new-name cv2-dup --name cv2])
        assert(result.err[/--organization-id, --organization, --organization-label is required/],
               "Organization option requirements are validated")
      end

      it 'allows organization id' do
        expect_content_view_search('1', 'cv2', 2)
        api_expects(:content_views, :copy) do |p|
          p['id'] == 2 && p['name'] == 'cv2-dup'
        end
        run_cmd(%w[content-view copy --name cv2 --new-name cv2-dup --organization-id 1])
      end

      it 'allows organization name' do
        expect_organization_search('org1', 1)
        expect_content_view_search(1, 'cv2', 2)
        api_expects(:content_views, :copy) do |p|
          p['id'] == 2 && p['name'] == 'cv2-dup'
        end
        run_cmd(%w[content-view copy --name cv2 --new-name cv2-dup --organization org1])
      end

      it 'allows organization label' do
        expect_organization_search('org1', 1, field: 'label')
        expect_content_view_search(1, 'cv2', 2)
        api_expects(:content_views, :copy) do |p|
          p['id'] == 2 && p['name'] == 'cv2-dup'
        end
        run_cmd(%w[content-view copy --name cv2 --new-name cv2-dup --organization-label org1])
      end
    end
  end
end
