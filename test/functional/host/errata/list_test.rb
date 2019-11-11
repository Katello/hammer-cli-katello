require File.join(File.dirname(__FILE__), '../../test_helper')
require_relative '../../lifecycle_environment/lifecycle_environment_helpers'

describe 'host errata listing' do
  include LifecycleEnvironmentHelpers

  before do
    @cmd = %w(host errata list)
  end

  let(:org_id) { 1 }
  let(:host_id) { 2 }
  let(:lifecycle_env_id) { 3 }
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

  it "lists the host errata belonging to a lifecycle-environment by name" do
    params = ["--host-id=#{host_id}", "--organization-id=#{org_id}", '--lifecycle-environment=test']

    expect_lifecycle_environment_search(org_id.to_s, 'test', lifecycle_env_id)

    ex = api_expects(:host_errata, :index, 'host errata list').
         with_params('host_id': host_id,
                     'environment_id': lifecycle_env_id,
                     'page': 1,
                     'per_page': 1000)

    ex.returns(empty_response)
    expected_result = success_result("---|------------|------|-------|------------
ID | ERRATUM ID | TYPE | TITLE | INSTALLABLE
---|------------|------|-------|------------
")
    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
