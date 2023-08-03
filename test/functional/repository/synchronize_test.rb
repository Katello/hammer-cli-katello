require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../product/product_helpers')
require File.join(File.dirname(__FILE__), './repository_helpers')

describe 'Synchronize a repository' do
  include ForemanTaskHelpers
  include ProductHelpers
  include RepositoryHelpers

  before do
    @cmd = %w[repository synchronize]
  end

  let(:org_id) { 1 }
  let(:repo_id) { 2 }
  let(:product_id) { 3 }
  let(:sync_response) do
    {
      'id' => repo_id.to_s,
      'state' => 'planned'
    }
  end

  it "synchronizes a repository" do
    params = ["--id=#{repo_id}"]

    ex = api_expects(:repositories, :sync, 'Repository is synced') do |par|
      par['id'] == repo_id
    end

    ex.returns(sync_response)

    expect_foreman_task('3')

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
  end

  it "synchronizes a repository with a repository name" do
    params = ["--name=test_repo", "--product=test_product", "--organization-id=#{org_id}"]

    expect_product_search(org_id, "test_product", product_id)

    expect_repository_search(product_id, "test_repo", repo_id)

    ex = api_expects(:repositories, :sync, 'Repository is synced') do |par|
      par['id'] == repo_id
    end

    ex.returns(sync_response)

    expect_foreman_task('3')

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
  end
end
