require_relative '../test_helper'
require 'hammer_cli_katello/content_view'

module HammerCLIKatello
  describe ContentView do
    describe 'AddRepositoryCommand' do
      it 'allows adding a repository by ID' do
        ex = api_expects(:organizations, :index) do |p|
          p[:search] == "name = \"org1\""
        end
        ex.returns(index_response([{'id' => 1}]))

        api_expects(:content_views, :index) do |p|
          p['name'] == 'cv' && p['organization_id'] == 1
        end

        run_cmd(%w(content-view add-repository --organization org1 --name cv --repository-id 1))
      end
    end
  end
end
