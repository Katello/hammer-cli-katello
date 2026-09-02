require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../lifecycle_environment/lifecycle_environment_helpers')

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

    expected = success_result("---|------|---------|----------|--------------|---------------|----
ID | NAME | PRODUCT | ORPHANED | CONTENT TYPE | CONTENT LABEL | URL
---|------|---------|----------|--------------|---------------|----
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

    expected = CommandExpectation.new("---|------|---------|----------|--------------|---------------|----
ID | NAME | PRODUCT | ORPHANED | CONTENT TYPE | CONTENT LABEL | URL
---|------|---------|----------|--------------|---------------|----
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

    expected = CommandExpectation.new("---|------|---------|----------|--------------|---------------|----
ID | NAME | PRODUCT | ORPHANED | CONTENT TYPE | CONTENT LABEL | URL
---|------|---------|----------|--------------|---------------|----
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

    expected = CommandExpectation.new("---|------|---------|----------|--------------|---------------|----
ID | NAME | PRODUCT | ORPHANED | CONTENT TYPE | CONTENT LABEL | URL
---|------|---------|----------|--------------|---------------|----
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected, result)
  end

  it "lists the repositories with container upstream name" do
    params = ['--organization-id=1', '--fields=ALL']

    ex = api_expects(:repositories, :index, 'repositories list with upstream container name') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(empty_response)

    expected = CommandExpectation.new("---|------|---------|----------|--------------|---------------|-----|-------------------------
ID | NAME | PRODUCT | ORPHANED | CONTENT TYPE | CONTENT LABEL | URL | UPSTREAM REPOSITORY NAME
---|------|---------|----------|--------------|---------------|-----|-------------------------
")

    result = run_cmd(@cmd + params)
    assert_cmd(expected, result)
  end

  it "shows orphaned status from product in repository list" do
    params = ["--organization-id=#{org_id}"]

    ex = api_expects(:repositories, :index, 'Organizations repositories list with orphaned') do |par|
      par['organization_id'] == org_id && par['page'] == 1 &&
        par['per_page'] == 1000
    end

    ex.returns(
      "total" => 1,
      "subtotal" => 1,
      "page" => "1",
      "per_page" => "1000",
      "error" => nil,
      "search" => nil,
      "sort" => {
        "by" => nil,
        "order" => nil
      },
      "results" => [
        {
          "id" => 2,
          "name" => "RHEL ELS Optional",
          "content_type" => "yum",
          "content_label" => "rhel-7-server-els-optional-rpms",
          "url" => "https://cdn.redhat.com/content/els/rhel/server/7/7Server/x86_64/optional/os",
          "product" => {
            "id" => 250,
            "name" => "RHEL ELS",
            "orphaned" => true,
            "redhat" => true
          }
        }
      ]
    )

    result = run_cmd(@cmd + params)
    assert_equal 0, result.exit_code
    assert_match(/ORPHANED/, result.out)
    assert_match(/RHEL ELS Optional/, result.out)
    assert_match(/\byes\b|\btrue\b/i, result.out)
  end
end
