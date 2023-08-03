require File.join(File.dirname(__FILE__), '../../test_helper')
require 'hammer_cli_katello/content_export'

describe 'content-export list' do
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

  it 'allows minimal options' do
    ex = api_expects(:content_exports, :index)

    ex.returns(empty_response)
    # rubocop:disable Layout/LineLength
    expected_result = success_result('---|--------------------|------|------|----------------------|-------------------------|------------|-----------
ID | DESTINATION SERVER | PATH | TYPE | CONTENT VIEW VERSION | CONTENT VIEW VERSION ID | CREATED AT | UPDATED AT
---|--------------------|------|------|----------------------|-------------------------|------------|-----------
')
    # rubocop:enable Layout/LineLength
    result = run_cmd(%w[content-export list])
    assert_cmd(expected_result, result)
  end

  it 'works with content-view-id only' do
    api_expects(:content_view_versions, :index).returns(empty_response)

    ex = api_expects(:content_exports, :index)

    ex.returns(empty_response)
    # rubocop:disable Layout/LineLength
    expected_result = success_result('---|--------------------|------|------|----------------------|-------------------------|------------|-----------
ID | DESTINATION SERVER | PATH | TYPE | CONTENT VIEW VERSION | CONTENT VIEW VERSION ID | CREATED AT | UPDATED AT
---|--------------------|------|------|----------------------|-------------------------|------------|-----------
')
    # rubocop:enable Layout/LineLength
    result = run_cmd(%w[content-export list --content-view-id=1])
    assert_cmd(expected_result, result)
  end

  it 'works with content-view-version-id only' do
    ex = api_expects(:content_exports, :index)

    ex.returns(empty_response)
    # rubocop:disable Layout/LineLength
    expected_result = success_result('---|--------------------|------|------|----------------------|-------------------------|------------|-----------
ID | DESTINATION SERVER | PATH | TYPE | CONTENT VIEW VERSION | CONTENT VIEW VERSION ID | CREATED AT | UPDATED AT
---|--------------------|------|------|----------------------|-------------------------|------------|-----------
')
    # rubocop:enable Layout/LineLength
    result = run_cmd(%w[content-export list --content-view-version-id=1])
    assert_cmd(expected_result, result)
  end
end
