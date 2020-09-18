require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'host trace resolve' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(host traces resolve)
  end

  let(:host_id) { '2' }
  let(:task_id) { '5' }
  let(:response) do
    {
      'id' => task_id,
      'state' => 'stopped'
    }
  end

  it "resolves traces on a host" do
    trace_ids = [3]
    params = ["--host-id=#{host_id}", "--trace-ids=#{trace_ids}"]

    ex = api_expects(:host_tracer, :resolve)

    ex.returns(response)

    expect_foreman_task(task_id)

    run_cmd(@cmd + params)
  end
end
