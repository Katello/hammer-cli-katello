require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../host_helpers')

describe 'host subscription content-override' do
  include HostHelpers

  before do
    @cmd = %w(host subscription content-override)
  end

  it "attach a content label" do
    label = "foo"
    value = 'default'
    id = 20
    params = ["--host-id=#{id}", "--content-label=#{label} --value=#{value}"]
    ex = api_expects(:host_subscriptions, :content_override, "content override") do |par|
      par['host_id'] == id && par[:content_overrides][0][:label] == label &&
        par[:content_overrides][0][:value] == value
    end
    ex.returns({})

    expected_result = success_result(
      'Updated content override'
    )

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
