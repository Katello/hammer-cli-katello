require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../host_helpers')

describe 'host subscription auto-attach' do
  include HostHelpers

  before do
    @cmd = %w(host subscription auto-attach)
  end
  it "auto-attach to a host" do
    params = ['--host-id=3']
    ex = api_expects(:host_subscriptions, :auto_attach, "auto-attach subs host") do |par|
      par['host_id'] == 3
    end
    ex.returns({})

    expected_result = success_result(
      'Auto attached subscriptions to the host successfully
'
    )

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "resolves id from name" do
    params = ['--host=boo']
    api_expects(:host_subscriptions, :auto_attach, "auto-attach subs host") do |par|
      par['host_id'].to_s == "3"
    end
    expect_host_search('boo', '3')

    run_cmd(@cmd + params)
  end
end
