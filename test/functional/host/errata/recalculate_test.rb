require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'recalculate errata' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(host errata recalculate)
  end

  let(:host_id) { 1 }
  let(:task_id) { '5' }
  let(:response) do
    {
      'id' => task_id,
      'state' => 'stopped'
    }
  end

  it "recalculates errata for a host" do
    params = ["--host-id=#{host_id}"]

    api_expects(:host_errata, :applicability, 'Host errata recalculate')
      .with_params('host_id' => host_id)
      .returns(response)

    expect_foreman_task(task_id)

    run_cmd(@cmd + params)
  end

  it "applies an errata to a host with async flag" do
    params = ["--host-id=#{host_id}", "--async"]

    api_expects(:host_errata, :applicability, 'Host errata recalculate')
      .with_params('host_id' => host_id)
      .returns(response)

    run_cmd(@cmd + params)
  end
end
