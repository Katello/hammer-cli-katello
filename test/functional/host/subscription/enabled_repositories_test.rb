require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'host enabled-repositories listing' do
  before do
    @cmd = %w[host subscription enabled-repositories]
  end

  let(:host_id) { 1 }
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
    ex = api_expects(:host_subscriptions,
                     :enabled_repositories, 'host subscription enabled-repositories')
    ex.returns(empty_response)
    # rubocop:disable Layout/LineLength
    expected_result = success_result("---|------|-------|--------------|----------|-----------------|-------------------|----------------------|------------------|-------------
ID | NAME | LABEL | CONTENT TYPE | CHECKSUM | CONTENT VIEW ID | CONTENT VIEW NAME | CONTENT VIEW VERSION | ENVIRONMENT NAME | PRODUCT NAME
---|------|-------|--------------|----------|-----------------|-------------------|----------------------|------------------|-------------
")
    # rubocop:enable Layout/LineLength
    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
