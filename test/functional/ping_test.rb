require_relative 'test_helper'

describe 'ping' do
  it 'does not require authentication' do
    api_expects(:ping, :index).returns(
      'status' => 'ok',
      'services' => {
        'foreman_tasks' => {'status' => 'ok', 'duration_ms' => '34'},
        'foreman_auth' => {'status' => 'ok', 'duration_ms' => '34'},
        'candlepin' => {'status' => 'ok', 'duration_ms' => '34'},
        'candlepin_events' => {'status' => 'ok', 'message' => '0 messages', 'duration_ms' => '34'},
        'candlepin_auth' => {'status' => 'ok', 'duration_ms' => '34'},
        'katello_events' => {'status' => 'ok', 'message' => '0 messages', 'duration_ms' => '34'},
        'pulp' => {'status' => 'ok', 'duration_ms' => '34'},
        'pulp_auth' => {'status' => 'ok', 'duration_ms' => '34'},
        'pulp3' => {'status' => 'ok', 'duration_ms' => '34'}
      }
    )

    run_cmd(%w(ping katello))
  end
end
