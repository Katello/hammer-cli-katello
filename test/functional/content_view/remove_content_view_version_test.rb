require_relative '../test_helper'
require 'hammer_cli_katello/content_view'

module HammerCLIKatello
  describe ContentView::RemoveContentViewVersionCommand do
    it 'allows minimal options' do
      ex = api_expects(:content_views, :show) do |p|
        p[:id] == '1'
      end
      ex.returns('id' => 1, 'component_ids' => [1, 3, 6])
      api_expects(:content_views, :update) do |p|
        p['id'] == '1' && p['component_ids'] == %w(1 3)
      end
      run_cmd(%w(content-view remove-version --id 1 --content-view-version-id 6))
    end

    it 'resolves content view version ID' do
      ex = api_expects(:content_view_versions, :index) do |p|
        p['content_view_id'] == '3' && p['version'] == '2.1'
      end
      ex.returns(index_response([{'id' => 6}]))
      ex.returns('id' => 1, 'component_ids' => [1, 3, 6])
      ex = api_expects(:content_views, :show) do |p|
        p[:id] == '1'
      end
      ex.returns('id' => 1, 'component_ids' => [1, 3])
      api_expects(:content_views, :update) do |p|
        p['id'] == '1' && p['component_ids'] == %w(1 3)
      end
      run_cmd(%w(content-view remove-version --id 1 --content-view-version-content-view-id 3
                 --content-view-version 2.1))
    end
  end
end
