require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../lifecycle_environment/lifecycle_environment_helpers')

require 'hammer_cli_katello/content_view_puppet_module'

describe 'listing repositories' do
  include LifecycleEnvironmentHelpers

  before do
    @cmd = %w(repository list)
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

  it "lists an organizations repositories" do
    params = ["--organization-id=#{org_id}"]

    ex = api_expects(:repositories, :index, 'Organizations repositories list') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected_result = success_result("---|------|---------|--------------|----
ID | NAME | PRODUCT | CONTENT TYPE | URL
---|------|---------|--------------|----
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "lists the repositories belonging to a lifecycle-environment by name" do
    params = ['--organization-id=1', '--environment=test']

    expect_lifecycle_environment_search(org_id, 'test', lifecycle_env_id)

    ex = api_expects(:repositories, :index, 'lifecycle repositories list') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected_result = CommandExpectation.new("---|------|---------|--------------|----
ID | NAME | PRODUCT | CONTENT TYPE | URL
---|------|---------|--------------|----
", "Warning: Option --environment is deprecated. Use --lifecycle-environment instead\n")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
