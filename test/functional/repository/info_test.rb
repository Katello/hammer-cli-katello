require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), '../product/product_helpers')
require File.join(File.dirname(__FILE__), './repository_helpers')

describe "get repository info" do
  include ProductHelpers
  include RepositoryHelpers

  before do
    @cmd = %w(repository info)
  end

  let(:org_id) { 1 }
  let(:product_id) { 2 }
  let(:repo_id) { 3 }

  it "Shows information about a repository" do
    params = ["--id=#{repo_id}"]

    ex = api_expects(:repositories, :show, "Get info") do |par|
      par["id"] == repo_id.to_s
    end

    ex.returns({})

    result = run_cmd(@cmd + params)
    assert(result.exit_code, 0)
  end

  it "Shows information about a repository with organization-id and product name" do
    params = ["--name=test_repo", "--product=test_product", "--organization-id=#{org_id}"]

    expect_product_search(org_id, 'test_product', product_id)

    expect_repository_search(org_id, product_id, 'test_repo', repo_id)

    ex2 = api_expects(:repositories, :show, "Get info") do |par|
      par["id"] == repo_id
    end

    ex2.returns({})

    result = run_cmd(@cmd + params)
    assert(result.exit_code, 0)
  end
end
