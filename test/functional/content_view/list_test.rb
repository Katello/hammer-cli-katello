require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../lifecycle_environment/lifecycle_environment_helpers')

require 'hammer_cli_katello/content_view_puppet_module'

describe 'listing content-views' do
  include LifecycleEnvironmentHelpers

  before do
    @cmd = %w(content-view list)
  end

  let(:org_id) { 1 }
  let(:lifecycle_env_id) { 1 }
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

  it "lists an organizations content-views" do
    params = ["--organization-id=#{org_id}"]

    ex = api_expects(:content_views, :index, 'Organizations content-views list') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)
    expected_result = success_result("----------------|------|-------|-----------|---------------
CONTENT VIEW ID | NAME | LABEL | COMPOSITE | REPOSITORY IDS
----------------|------|-------|-----------|---------------
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "lists the content-views belonging to a lifecycle-environment by name" do
    params = ["--organization-id=#{org_id}", '--lifecycle-environment=test']

    expect_lifecycle_environment_search(org_id, 'test', lifecycle_env_id).at_least_once

    ex = api_expects(:content_views, :index, 'lifecycles content-views list') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)
    expected_result = success_result("----------------|------|-------|-----------|---------------
CONTENT VIEW ID | NAME | LABEL | COMPOSITE | REPOSITORY IDS
----------------|------|-------|-----------|---------------
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
