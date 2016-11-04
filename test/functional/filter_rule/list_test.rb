require_relative '../test_helper'
require 'hammer_cli_katello/filter_rule'

module HammerCLIKatello
  describe FilterRule::ListCommand do
    it 'allows minimal options' do
      api_expects(:content_view_filter_rules, :index) do |p|
        p['content_view_filter_id'] == 1
      end
      run_cmd(%w(content-view filter rule list --content-view-filter-id 1))
    end

    it 'allows name resolution with content-view-id' do
      ex = api_expects(:content_view_filters, :index) do |p|
        p['name'] == 'cvf1' && p['content_view_id'] == 3
      end
      ex.returns(index_response([{'id' => 1}]))

      api_expects(:content_view_filter_rules, :index) do |p|
        p['content_view_filter_id'] == 1
      end
      run_cmd(%w(content-view filter rule list --content-view-filter cvf1 --content-view-id 3))
    end

    describe 'organization' do
      it 'ID can be specified to resolve content view name' do
        ex = api_expects(:content_views, :index) do |p|
          p['name'] == 'cv3' && p['organization_id'] == '6'
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:content_view_filters, :index) do |p|
          p['name'] == 'cvf1' && p['content_view_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:content_view_filter_rules, :index) do |p|
          p['content_view_filter_id'] == 1
        end
        run_cmd(%w(content-view filter rule list --content-view-filter cvf1 --organization-id 6
                   --content-view cv3))
      end

      it 'name can be specified to resolve content view name' do
        ex = api_expects(:organizations, :index) do |p|
          p[:search] == "name = \"org6\""
        end
        ex.returns(index_response([{'id' => 6}]))

        ex = api_expects(:content_views, :index) do |p|
          p['name'] == 'cv3' && p['organization_id'] == 6
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:content_view_filters, :index) do |p|
          p['name'] == 'cvf1' && p['content_view_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:content_view_filter_rules, :index) do |p|
          p['content_view_filter_id'] == 1
        end
        run_cmd(%w(content-view filter rule list --content-view-filter cvf1 --organization org6
                   --content-view cv3))
      end

      it 'label can be specified to resolve content view name' do
        ex = api_expects(:organizations, :index) do |p|
          p[:search] == "label = \"org6\""
        end
        ex.returns(index_response([{'id' => 6}]))

        ex = api_expects(:content_views, :index) do |p|
          p['name'] == 'cv3' && p['organization_id'] == 6
        end
        ex.returns(index_response([{'id' => 3}]))

        ex = api_expects(:content_view_filters, :index) do |p|
          p['name'] == 'cvf1' && p['content_view_id'] == 3
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:content_view_filter_rules, :index) do |p|
          p['content_view_filter_id'] == 1
        end
        run_cmd(%w(content-view filter rule list --content-view-filter cvf1 --organization-label
                   org6 --content-view cv3))
      end
    end
  end
end
