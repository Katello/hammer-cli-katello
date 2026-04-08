require_relative 'test_helper'

describe 'ping' do
  let(:standard_response_services) do
    {
      'katello_agent' =>
        {'status' => 'ok', 'message' => '0 Processed, 0 Failed', 'duration_ms' => '34'},
      'foreman_tasks' =>
        {'status' => 'ok', 'duration_ms' => '34'},
      'candlepin' => {'status' => 'ok', 'duration_ms' => '34'},
      'candlepin_auth' =>
        {'status' => 'ok', 'duration_ms' => '34'},
      'katello_events' =>
        {'status' => 'ok', 'message' => '0 Processed, 0 Failed', 'duration_ms' => '34'},
      'pulp3' =>
        {'status' => 'ok', 'duration_ms' => '34'},
      'pulp3_content' =>
        {'status' => 'ok', 'duration_ms' => '34'}
    }
  end
  let(:standard_response) do
    {
      'status' => 'ok',
      'services' => standard_response_services
    }
  end
  let(:standard_response_keys) do
    %w(katello_agent foreman_tasks candlepin
       candlepin_auth katello_events pulp3 pulp3_content).sort
  end
  let(:hammer_ping) { %w(ping katello) }

  it 'does not require authentication' do
    api_expects(:ping, :index).returns(standard_response)

    run_cmd(hammer_ping)
  end

  it "includes all keys" do
    api_expects(:ping, :index).returns(standard_response)

    result = JSON.parse(run_cmd(%w(--output=json ping katello))&.out)&.first&.keys&.sort
    expected = standard_response_keys

    assert_equal result, expected
  end

  it "skips katello_agent if not included in API response" do
    response_without_katello_agent = {
      'status' => 'ok',
      'services' => standard_response_services.select { |k, _v| k != 'katello_agent' }
    }
    api_expects(:ping, :index).returns(response_without_katello_agent)
    result = JSON.parse(run_cmd(%w(--output=json ping katello))&.out)&.first&.keys&.sort
    expected = standard_response_keys.select { |k| k != 'katello_agent' }

    assert_equal result, expected
  end
end
