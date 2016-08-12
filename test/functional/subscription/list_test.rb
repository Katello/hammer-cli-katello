require_relative '../test_helper'
require 'hammer_cli_katello/subscription'

module HammerCLIKatello
  describe SubscriptionCommand::ListCommand do
    before do
      @cmd = %w(subscription list)
    end

    let(:org_id) { 1 }

    it "returns the correct subscription type" do
      cmd = SubscriptionCommand::ListCommand.new({})
      assert_equal("Physical", cmd.get_subscription_type("virt_only" => false))

      hostname = "boo.com"
      with_hostname = cmd.get_subscription_type("virt_only" => true, "host" => {"name" => hostname})
      assert(with_hostname.include?(hostname))

      assert_equal("Temporary",
                   cmd.get_subscription_type("virt_only" => true, "unmapper_guest" => true))

      assert_equal("Virtual",
                   cmd.get_subscription_type("virt_only" => true))
    end

    it "lists an organizations subscriptions" do
      params = ["--organization-id=#{org_id}"]

      ex = api_expects(:subscriptions, :index, 'Subscription list') do |par|
        par['organization_id'] == org_id
      end

      ex.returns(index_response([]))

      result = run_cmd(@cmd + params)

      fields = ['ID', 'UUID', 'NAME', 'TYPE', 'CONTRACT', 'ACCOUNT', 'SUPPORT',
                'END DATE', 'QUANTITY', 'CONSUMED']
      expected_result = success_result(IndexMatcher.new([fields, []]))
      assert_cmd(expected_result, result)
    end

    it 'requires organization options' do
      expected_error = "Could not find organization"
      result = run_cmd(%w(subscription list))
      assert_equal(expected_error, result.err[/#{expected_error}/])
    end

    it 'allows organization name' do
      api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:subscriptions, :index) { |par| par['organization_id'].to_i == 1 }

      run_cmd(%w(subscription list --organization org1))
    end

    it 'allows organization label' do
      api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
        .returns(index_response([{'id' => 1}]))

      api_expects(:subscriptions, :index) { |par| par['organization_id'].to_i == 1 }

      run_cmd(%w(subscription list --organization-label org1))
    end

    it 'allows host id' do
      api_expects(:subscriptions, :index) { |par| par['host_id'] == 1 }
      run_cmd(%w(subscription list --organization-id 1 --host-id 1))
    end

    it 'allows host name' do
      api_expects(:hosts, :index) { |par| par[:search] == "name = \"host1\"" }
        .returns(index_response([{'id' => 1}]))
      api_expects(:subscriptions, :index) { |par| par['host_id'] == 1 }
      run_cmd(%w(subscription list --organization-id 1 --host host1))
    end

    it 'allows activation key id' do
      api_expects(:subscriptions, :index) { |par| par['activation_key_id'] == 1 }
      run_cmd(%w(subscription list --organization-id 1 --activation-key-id 1))
    end

    it 'allows activation key name' do
      api_expects(:activation_keys, :index) { |par| par['name'] == "ak1" }
        .returns(index_response([{'id' => 1}]))
      api_expects(:subscriptions, :index) { |par| par['activation_key_id'] == 1 }
      run_cmd(%w(subscription list --organization-id 1 --activation-key ak1))
    end
  end
end
