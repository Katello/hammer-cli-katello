require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'host trace listing' do
  before do
    @cmd = %w(host traces list)
  end

  let(:host_id) { 2 }
  let(:empty_response) do
    {
      "total" => 0,
      "subtotal" => 0,
      "page" => "1",
      "per_page" => "1000",
      "error" => nil,
      "search" => nil,
      "sort" => {
        "by" => nil,
        "order" => nil
      },
      "results" => []
    }
  end

  it 'allows listing by host' do
    params = ["--host-id=#{host_id}"]
    ex = api_expects(:host_tracer, :index, 'host traces list')

    ex.returns(empty_response)
    expected_result = success_result("---------|-------------|--------|-----
TRACE ID | APPLICATION | HELPER | TYPE
---------|-------------|--------|-----
")
    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
