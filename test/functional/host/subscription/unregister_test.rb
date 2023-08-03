require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../host_helpers')

describe 'host subscription unregister' do
  include HostHelpers

  before do
    @cmd = %w[host subscription unregister]
  end

  it "unregisters the host" do
    params = ['--host-id=3']
    ex = api_expects(:host_subscriptions, :destroy, 'Host unregister') do |par|
      par['host_id'] == 3
    end
    ex.returns({})

    expected_result = success_result(
      'Host unregistered.
'
    )

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "resolves id from name" do
    params = ['--host=host1']

    api_expects(:host_subscriptions, :destroy, 'Host unregister') do |par|
      par['host_id'].to_i == 3
    end
    expect_host_search('host1', '3')

    run_cmd(@cmd + params)
  end
end
