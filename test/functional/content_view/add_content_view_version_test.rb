require_relative '../test_helper'
require_relative '../organization/organization_helpers'
require_relative '../content_view/content_view_helpers'
require 'hammer_cli_katello/content_view'

module HammerCLIKatello
  describe ContentView::AddContentViewVersionCommand do
    include OrganizationHelpers
    include ContentViewHelpers

    it 'allows minimal options' do
      ex = api_expects(:content_views, :show) do |p|
        p[:id] == '1'
      end
      ex.returns('id' => 1, 'component_ids' => [1, 3])
      api_expects(:content_views, :update) do |p|
        p['id'] == '1' && p['component_ids'] == %w(1 3 6)
      end
      run_cmd(%w(content-view add-version --id 1 --content-view-version-id 6))
    end

    it 'resolves content view version ID' do
      ex = api_expects(:content_view_versions, :index) do |p|
        p['content_view_id'] == 3 && p['version'] == '2.1'
      end
      ex.returns(index_response([{'id' => 6}]))
      ex.returns('id' => 1, 'component_ids' => [1, 3])
      ex = api_expects(:content_views, :show) do |p|
        p[:id] == '1'
      end
      ex.returns('id' => 1, 'component_ids' => [1, 3])
      api_expects(:content_views, :update) do |p|
        p['id'] == '1' && p['component_ids'] == %w(1 3 6)
      end
      run_cmd(%w(content-view add-version --id 1 --content-view-id 3 --content-view-version 2.1))
    end

    describe 'OrganizationOptions' do
      it 'requires organization if content view name is supplied' do
        api_expects_no_call
        result = run_cmd(%w(content-view add-version --name cv1))
        assert(result.err[/--organization-id, --organization, --organization-label is required/],
               "Organization option requirements are validated")
      end

      it 'allows organization id' do
        expect_content_view_search('1', 'cv2', 2)
        ex = api_expects(:content_views, :show) do |p|
          p[:id] == 2
        end
        ex.returns('id' => 2, 'component_ids' => [1, 2])
        api_expects(:content_views, :update) do |p|
          p['id'] == 2 && p['component_ids'] == %w(1 2 3)
        end
        run_cmd(%w(content-view add-version --name cv2 --organization-id 1
                   --content-view-version-id 3))
      end

      it 'allows organization name' do
        expect_organization_search('org1', 1)
        expect_content_view_search(1, 'cv2', 2)
        ex = api_expects(:content_views, :show) do |p|
          p[:id] == 2
        end
        ex.returns('id' => 2, 'component_ids' => [1, 2])
        api_expects(:content_views, :update) do |p|
          p['id'] == 2 && p['component_ids'] == %w(1 2 3)
        end
        run_cmd(%w(content-view add-version --name cv2 --organization org1
                   --content-view-version-id 3))
      end

      it 'allows organization label' do
        expect_organization_search('org1', 1, field: 'label')
        expect_content_view_search(1, 'cv2', 2)
        ex = api_expects(:content_views, :show) do |p|
          p[:id] == 2
        end
        ex.returns('id' => 2, 'component_ids' => [1, 2])
        api_expects(:content_views, :update) do |p|
          p['id'] == 2 && p['component_ids'] == %w(1 2 3)
        end
        run_cmd(%w(content-view add-version --name cv2 --organization-label org1
                   --content-view-version-id 3))
      end
    end
  end
end
