require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../lifecycle_environment/lifecycle_environment_helpers')

require 'hammer_cli_katello/content_view_puppet_module'

describe 'listing content credentials' do
  include LifecycleEnvironmentHelpers

  before do
    @cmd = %w(content-credentials list)
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

  it "lists an organizations keys" do
    params = ["--organization-id=#{org_id}"]

    ex = api_expects(:content_credentials, :index, 'Organization content credentials list') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected_result = success_result("---|------|-------------
ID | NAME | CONTENT TYPE
---|------|-------------
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "lists the keys by content-type" do
    params = ['--content-type=gpg', "--organization-id=#{org_id}"]

    ex = api_expects(:content_credentials, :index, 'content-type') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected_result = CommandExpectation.new("---|------|-------------
ID | NAME | CONTENT TYPE
---|------|-------------
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
