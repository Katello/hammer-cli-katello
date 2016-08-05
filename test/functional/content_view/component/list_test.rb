require_relative '../../test_helper'
require 'hammer_cli_katello/content_view_component'
module HammerCLIKatello
  describe ContentViewComponent::ListCommand do
    before do
      @cmd = %w(content-view component list)
    end

    it 'expects composite_content_view_id as minimal options' do
      api_expects(:content_view_components, :index, "component list") do |p|
        p["composite_content_view_id"].to_s == "1"
      end
      run_cmd(@cmd + ["--composite-content-view-id=1"])
    end

    it 'expects composite_content_view and organization_id as other options' do
      api_expects(:content_views, :index) do |p|
        p['name'] == "lol" && p["organization_id"].to_s == "1"
      end
      run_cmd(@cmd + %w(--composite-content-view=lol --organization-id=1))
    end

    it 'label' do
      api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
        .at_least_once.returns(index_response([{'id' => 1}]))

      api_expects(:content_view_components, :index) do |p|
        p["composite_content_view_id"].to_s == "1"
      end

      api_expects(:content_views, :index).
        at_least_once.returns(index_response([{'id' => 1}])) do |p|
        p['name'] == "lol" && p["organization_id"].to_s == "1"
      end

      run_cmd(@cmd + %w(--composite-content-view=lol --organization-label=org1))
    end

    it 'name' do
      api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
        .at_least_once.returns(index_response([{'id' => 1}]))

      api_expects(:content_view_components, :index) do |p|
        p["composite_content_view_id"].to_s == "1"
      end

      api_expects(:content_views, :index).
        at_least_once.returns(index_response([{'id' => 1}])) do |p|
        p['name'] == "lol" && p["organization_id"].to_s == "1"
      end

      run_cmd(@cmd + %w(--composite-content-view=lol --organization=org1))
    end
  end
end
