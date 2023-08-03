require_relative '../test_helper'
require 'hammer_cli_katello/activation_key'

module HammerCLIKatello
  describe ActivationKeyCommand do
    describe UpdateCommand do
      it 'allows promoting a content view' do
        ex = api_expects(:organizations, :index) do |p|
          p[:search] == "name = \"org1\""
        end
        ex.at_least_once.returns(index_response([{'id' => 1}]))

        ex = api_expects(:activation_keys, :index) do |p|
          p['name'] == 'ak' && p['organization_id'] == 1
        end
        ex.returns(index_response([{'id' => 6}]))

        api_expects(:activation_keys, :update) do |p|
          p['id'] == 6 && p['organization_id'] == 1
        end

        run_cmd(%w[activation-key update --organization org1 --name ak --auto-attach false])
      end
    end
  end
end
