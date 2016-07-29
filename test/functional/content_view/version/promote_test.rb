require_relative '../../test_helper'
require 'hammer_cli_katello/content_view_puppet_module'

module HammerCLIKatello
  describe ContentViewPuppetModule do
    it 'allows promoting a content view' do
      ex = api_expects(:organizations, :index) do |p|
        p[:search] == "name = \"org1\""
      end
      ex.at_least_once.returns(index_response([{'id' => 1}]))

      ex = api_expects(:content_views, :index) do |p|
        p['name'] == 'cv' && p['organization_id'] == 1
      end
      ex.returns(index_response([{'id' => 3}]))

      ex = api_expects(:content_view_versions, :index) do |p|
        p['version'] == '1' && p['content_view_id'] == 3
      end
      ex.returns(index_response([{'id' => 6}]))

      ex = api_expects(:lifecycle_environments, :index) do |p|
        p['organization_id'] == 1 && p['name'] == 'test'
      end
      ex.returns(index_response([{'id' => 9}]))

      api_expects(:content_view_versions, :promote) do |p|
        p['id'] == 6 && p['environment_id'] == 9
      end

      run_cmd(%w(content-view version promote --organization org1 --content-view cv
                 --to-lifecycle-environment test --version 1 --async))
    end
  end
end
