require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'recalculate errata' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(host errata recalculate)
  end

  let(:host_id) { 1 }

  it "recalculates errata for a host" do
    params = ["--host-id=#{host_id}"]

    api_expects(:host_errata, :applicability, 'Host errata recalculate')
      .with_params('host_id' => host_id)
      .returns({})

    expected_result = success_result(
      'Errata recalculation started.
'
    )
    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
