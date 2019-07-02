require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../content_view_helpers')
require File.join(File.dirname(__FILE__), '../../organization/organization_helpers')

describe 'listing content view filters' do
  include ContentViewHelpers
  include OrganizationHelpers

  before do
    @cmd = %w(content-view filter list)
  end

  let(:org_id) { 1 }
  let(:org_label) { 'Ubik' }
  let(:cv_name) { "Trystero" }
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

  it "lists content view filters" do
    params = ["--content-view-id=1"]

    ex = api_expects(:content_view_filters, :index, 'Content view filters list') do |par|
      par['content_view_id'] == 1 && par['page'] == 1 && par['per_page'] == 1000
    end
    ex.returns(empty_response)

    expected_result = success_result("----------|------|-------------|------|----------
FILTER ID | NAME | DESCRIPTION | TYPE | INCLUSION
----------|------|-------------|------|----------
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "lists content view filters for a content view name and org id" do
    params = ["--organization-id=#{org_id}", "--content-view=#{cv_name}"]

    expect_content_view_search(org_id.to_s, cv_name, 1)

    ex = api_expects(:content_view_filters, :index, 'Content view filters list') do |par|
      par['content_view_id'] == 1 && par['page'] == 1 && par['per_page'] == 1000
    end
    ex.returns(empty_response)

    expected_result = success_result("----------|------|-------------|------|----------
FILTER ID | NAME | DESCRIPTION | TYPE | INCLUSION
----------|------|-------------|------|----------
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "lists content view filters for a content view name and org label" do
    params = ["--organization-label=#{org_label}", "--content-view=#{cv_name}"]

    expect_organization_search(org_label, org_id, field: 'label')
    expect_content_view_search(org_id, cv_name, 1)

    ex = api_expects(:content_view_filters, :index, 'Content view filters list') do |par|
      par['content_view_id'] == 1 && par['page'] == 1 && par['per_page'] == 1000
    end
    ex.returns(empty_response)

    expected_result = success_result("----------|------|-------------|------|----------
FILTER ID | NAME | DESCRIPTION | TYPE | INCLUSION
----------|------|-------------|------|----------
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it 'requires org name, label, or id if content view name is supplied' do
    params = ["--content-view=#{cv_name}"]
    expected_result = usage_error_result(
      @cmd,
      'At least one of options --organization-id, --organization, --organization-label is required.'
    )
    api_expects_no_call
    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
