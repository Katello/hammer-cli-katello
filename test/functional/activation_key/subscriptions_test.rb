require_relative '../test_helper'
require 'hammer_cli_katello/activation_key'

module HammerCLIKatello
  describe ActivationKeyCommand::SubscriptionsCommand do
    it 'requires organization options' do
      expected_error = "Could not find organization"
      result = run_cmd(%w(activation-key subscriptions --name test))
      assert_equal(result.err[/#{expected_error}/], expected_error)
    end

    it 'allows organization name' do
      api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:subscriptions, :index) { |par| par['organization_id'].to_i == 1 }

      run_cmd(%w(activation-key subscriptions --id 1 --organization org1))
    end

    it 'allows organization label' do
      api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:subscriptions, :index) { |par| par['organization_id'].to_i == 1 }

      run_cmd(%w(activation-key subscriptions --id 1 --organization-label org1))
    end

    it 'lists subscriptions available for the activation key' do
      api_expects(:subscriptions, :index) do |p|
        p['available_for'] == 'activation_key'
      end
      run_cmd(%w(activation-key subscriptions --organization-id 1 --id 1
                 --available-for activation_key))
    end

    it 'lists subscriptions used by the activation key' do
      api_expects(:subscriptions, :index) { |p| p['activation_key_id'] == '1' }
      run_cmd(%w(activation-key subscriptions --organization-id 1 --id 1))
    end

    it 'allows activation_key_name' do
      api_expects(:activation_keys, :index) { |p| p['name'] == 'ak1' }
        .returns(index_response([{'id' => 1}]))
      api_expects(:subscriptions, :index) { |p| p['activation_key_id'] == 1 }
      run_cmd(%w(activation-key subscriptions --organization-id 1 --name ak1))
    end

    it 'allows a subscription to be added to an activation key' do
      api_expects(:activation_keys, :add_subscriptions) do |p|
        p['id'] == 1 && p['subscription_id'] == 3
      end
      run_cmd(%w(activation-key add-subscription --id 1 --subscription-id 3))
    end

    it 'allows a subscription to be added by name to an activation key with org label' do
      api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
        .returns(index_response([{'id' => 1}]))
      api_expects(:subscriptions, :index) { |p| p['name'] == 'sub' }
        .returns(index_response([{'name' => 'sub'}]))
      api_expects(:activation_keys, :add_subscriptions) { |p| p['id'] == 1 }
      run_cmd(%w(activation-key add-subscription --id 1 --subscription sub
                 --organization-label org1))
    end

    it 'allows multiple subscriptions to be added to an activation key' do
      api_expects(:activation_keys, :add_subscriptions) do |p|
        p['id'] == 1 && p['subscriptions'] == [{'id' => '3'}, {'id' => '4'}]
      end
      run_cmd(%w(activation-key add-subscription --id 1 --subscriptions id=3,id=4))
    end
  end
end
