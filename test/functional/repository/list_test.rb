require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../lifecycle_environment/lifecycle_environment_helpers')

describe 'listing repositories' do
  include LifecycleEnvironmentHelpers

  before do
    @cmd = %w[repository list]
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

    expected = success_result("---|------|---------|--------------|---------------|----
ID | NAME | PRODUCT | CONTENT TYPE | CONTENT LABEL | URL
---|------|---------|--------------|---------------|----
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected, result)
  end

  it "lists the repositories belonging to a lifecycle-environment by name" do
    params = ['--organization-id=1', '--environment=test']

    expect_lifecycle_environment_search(org_id, 'test', lifecycle_env_id)

    ex = api_expects(:repositories, :index, 'lifecycle repositories list') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected = CommandExpectation.new("---|------|---------|--------------|---------------|----
ID | NAME | PRODUCT | CONTENT TYPE | CONTENT LABEL | URL
---|------|---------|--------------|---------------|----
", "Warning: Option --environment is deprecated. Use --lifecycle-environment instead\n")

    result = run_cmd(@cmd + params)
    assert_cmd(expected, result)
  end

  it "lists the repositories with a certain repository type" do
    params = ['--organization-id=1', '--content-type=yum']

    ex = api_expects(:repositories, :index, 'yum repositories list') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected = CommandExpectation.new("---|------|---------|--------------|---------------|----
ID | NAME | PRODUCT | CONTENT TYPE | CONTENT LABEL | URL
---|------|---------|--------------|---------------|----
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected, result)
  end

  it "lists the repositories with a certain content unit type" do
    params = ['--organization-id=1', '--with-content=srpm']

    ex = api_expects(:repositories, :index, 'yum repositories list') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected = CommandExpectation.new("---|------|---------|--------------|---------------|----
ID | NAME | PRODUCT | CONTENT TYPE | CONTENT LABEL | URL
---|------|---------|--------------|---------------|----
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected, result)
  end
end
