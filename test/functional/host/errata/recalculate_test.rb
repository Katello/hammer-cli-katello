require File.join(File.dirname(__FILE__), '../../test_helper')

require 'hammer_cli_katello/content_view_puppet_module'

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

    ex = api_expects(:host_errata, :applicability, 'Host errata recalculate') do |par|
      par['host_id'] == host_id
    end

    ex.returns(response)

    expect_foreman_task(task_id)

    run_cmd(@cmd + params)
  end

  it "applies an errata to a host with async flag" do
    params = ["--host-id=#{host_id}", "--async"]

    ex = api_expects(:host_errata, :applicability, 'Host errata recalculate') do |par|
      par['host_id'] == host_id
    end

    ex.returns(response)

    run_cmd(@cmd + params)
  end
end
