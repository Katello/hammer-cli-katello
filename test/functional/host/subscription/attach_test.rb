require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../host_helpers')

describe 'host subscription attach' do
  include HostHelpers

  before do
    @cmd = %w[host subscription attach]
  end
  it "attach a subscription to a host No Quantity" do
    params = ['--host-id=3', '--subscription-id=100']
    ex = api_expects(:host_subscriptions, :add_subscriptions, "attach host") do |par|
      par['host_id'] == 3 && par[:subscriptions][0][:id].to_s == '100' &&
        par[:subscriptions][0][:quantity].to_s == '1'
    end
    ex.returns({})

    expected_result = success_result(
      'Subscription attached to the host successfully.
'
    )

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "attach a subscription to a host with Quantity" do
    params = ['--host-id=3', '--subscription-id=100', "--quantity=10"]
    ex = api_expects(:host_subscriptions, :add_subscriptions, "attach host") do |par|
      par['host_id'] == 3 && par[:subscriptions][0][:id].to_s == '100' &&
        par[:subscriptions][0][:quantity].to_s == '10'
    end
    ex.returns({})

    expected_result = success_result(
      'Subscription attached to the host successfully.
'
    )

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "resolves id from name" do
    params = ['--host=boo', '--subscription-id=100']
    api_expects(:host_subscriptions, :add_subscriptions, "attach host") do |par|
      par['host_id'].to_s == "3" && par[:subscriptions][0][:id].to_s == '100' &&
        par[:subscriptions][0][:quantity].to_s == '1'
    end
    expect_host_search('boo', '3')

    run_cmd(@cmd + params)
  end
end
