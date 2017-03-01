require_relative '../../test_helper'
require 'hammer_cli_katello/content_view_puppet_module'

module HammerCLIKatello
  describe ContentViewPuppetModule do
    it 'allows adding a puppet module' do
      ex = api_expects(:organizations, :index) do |p|
        p[:search] == "name = \"org1\""
      end
      ex.returns(index_response([{'id' => 1}]))

      ex = api_expects(:content_views, :index) do |p|
        p['name'] == 'cv' && p['organization_id'] == 1
      end
      ex.returns(index_response([{'id' => 3}]))

      api_expects(:content_view_puppet_modules, :create) do |p|
        p['content_view_id'] == 3
      end

      run_cmd(%w(content-view puppet-module add --organization org1 --content-view cv --id 1))
    end
  end
end
