require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../host_helpers')
require 'hammer_cli_katello/host_subscription'

describe 'listing available product content' do
  include HostHelpers

  let(:host_id) { 1 }
  let(:empty_response_table) do
    <<~EOSTRING
      ---|------|------|-----|---------|-------|------------------|---------
      ID | NAME | TYPE | URL | GPG KEY | LABEL | DEFAULT ENABLED? | OVERRIDE
      ---|------|------|-----|---------|-------|------------------|---------
    EOSTRING
  end

  it "lists content available for a host" do
    ex = api_expects(:host_subscriptions, :product_content) do |p|
      p['id'] = host_id
    end
    ex.returns(index_response([]))
    assert_cmd(
      success_result(empty_response_table),
      run_cmd(%w[host subscription product-content --host-id 1])
    )
  end
end
