require_relative '../test_helper'
require 'hammer_cli_katello/activation_key'

module HammerCLIKatello
  describe ActivationKeyCommand do
    describe CreateCommand do
      it 'allows activation key creation' do
        ex = api_expects(:organizations, :index) do |p|
          p[:search] == "name = \"org1\""
        end
        ex.at_least_once.returns(index_response([{'id' => 1}]))

        ex = api_expects(:lifecycle_environments, :index) do |p|
          p['organization_id'] == 1 && p['name'] == 'test'
        end
        ex.returns(index_response([{'id' => 9}]))

        ex = api_expects(:content_views, :index) do |p|
          p['name'] == 'cv' && p['organization_id'] == 1
        end
        ex.returns(index_response([{'id' => 3}]))

        api_expects(:activation_keys, :create) do |p|
          p['name'] == 'ak' && p['environment_id'] == 9 && p['organization_id'] == 1 &&
            p['content_view_id'] == 3
        end

        run_cmd(%w[activation-key create --organization org1 --name ak --content-view cv
                   --lifecycle-environment test --unlimited-hosts])
      end
    end
  end
end
