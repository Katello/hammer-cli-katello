require File.join(File.dirname(__FILE__), '../test_helper')

describe 'listing acs' do
  before do
    @cmd = %w[alternate-content-source list]
  end

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

  let(:acs_response) do
    {
      'id' => 1,
      'name' => 'pizza',
      'alternate_content_source_type' => 'custom'
    }
  end

  it "lists acs and returns empty response" do
    ex = api_expects(:alternate_content_sources, :index, 'acs list') do |par|
      par['page'] == 1 && par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected_result = success_result("---|------|-----
ID | NAME | TYPE
---|------|-----
")

    result = run_cmd(@cmd)
    assert_cmd(expected_result, result)
  end

  it "lists acs and returns response" do
    ex = api_expects(:alternate_content_sources, :index, 'acs list') do |par|
      par['page'] == 1 && par['per_page'] == 1000
    end

    ex.returns(acs_response)

    expected_result = success_result("1  | pizza | custom
---|-------|-------
")

    result = run_cmd(@cmd)
    assert_cmd(expected_result, result)
  end
end
