require_relative '../test_helper'

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

      api_expects(:content_views, :publish) do |p|
        p['id'] == 3
      end

      run_cmd(%w(content-view publish --organization org1 --name cv --async))
    end
  end
end
