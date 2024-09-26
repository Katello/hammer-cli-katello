require_relative '../test_helper'
require 'hammer_cli_katello/associating_commands'

module HammerCLIKatello
  module AssociatingCommands
    module HostCollection
      describe AddHostCollectionCommand do
        it 'allows minimal options' do
          ex = api_expects(:activation_keys, :show) do |p|
            p[:id] == '1'
          end
          ex.returns('id' => 1, host_collections: [{}])

          api_expects(:activation_keys, :update) do |p|
            p['name'] == 'teskey' && p['organization_id'] == 1 && p['host_collection_ids'] == ['3']
          end

          run_cmd(%w(activation-key add-host-collection --organization-id 1
                     --host-collection-id 3 --id 1 --name teskey))
        end

        it 'allows resolving host collection name' do
          ex = api_expects(:host_collections, :index) do |p|
            p['name'] == 'hc3' && p['organization_id'] == 1
          end
          ex.returns(index_response([{'id' => 3}]))

          ex = api_expects(:activation_keys, :show) do |p|
            p[:id] == '1'
          end
          ex.returns(id: 1, host_collection_ids: [])

          api_expects(:activation_keys, :update) do |p|
            p['name'] == 'testkey' && p['organization_id'] == 1 && p['host_collection_ids'] == ['3']
          end

          run_cmd(%w(activation-key add-host-collection --organization-id 1
                     --host-collection hc3 --id 1 --name testkey))
        end

        it 'allows resolving activation key name' do
          ex = api_expects(:activation_keys, :index) do |p|
            p['name'] == 'ak1' && p['organization_id'] == 1
          end
          ex.at_least_once.returns(index_response([{'id' => 1}]))

          ex = api_expects(:activation_keys, :show) do |p|
            p[:id] == 1
          end
          ex.returns(id: 1, host_collections: [])

          api_expects(:activation_keys, :update) do |p|
            p['id'] == 1 && p['organization_id'] == 1 && p['host_collection_ids'] == ['3']
          end

          run_cmd(%w(activation-key add-host-collection --organization-id 1
                     --host-collection-id 3 --name ak1))
        end
      end
    end
  end
end
