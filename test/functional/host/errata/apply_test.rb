require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'apply an errata' do
  include ForemanTaskHelpers

  before do
    @cmd = %w[host errata apply]
  end

  let(:errata_id) { "RHEA-1111:1111" }
  let(:host_id) { 1 }
  let(:task_id) { '5' }
  let(:response) do
    {
      'id' => task_id,
      'state' => 'stopped'
    }
  end

  it "applies an errata to a host" do
    params = ["--errata-ids=#{errata_id}", "--host-id=#{host_id}"]

    ex = api_expects(:host_errata, :apply, 'Host errata apply') do |par|
      par['errata_ids'] == [errata_id] && par['host_id'] == host_id
    end

    ex.returns(response)

    expect_foreman_task(task_id)

    run_cmd(@cmd + params)
  end

  it "applies an errata to a host with async flag" do
    params = ["--errata-ids=#{errata_id}", "--host-id=#{host_id}", "--async"]

    ex = api_expects(:host_errata, :apply, 'Host errata apply') do |par|
      par['errata_ids'] == [errata_id] && par['host_id'] == host_id
    end

    ex.returns(response)

    run_cmd(@cmd + params)
  end
end
