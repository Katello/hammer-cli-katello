require_relative '../../test_helper'
require_relative '../../repository/repository_helpers'

describe 'content-view filter create' do
  include RepositoryHelpers
  before do
    @cmd = %w(content-view filter create)
    @base_params = ["--name=#{filter_name}", "--content-view-id=#{content_view_id}", "--type=rpm"]
  end

  let(:org_id) { 1 }
  let(:filter_name) { 'test_filter' }
  let(:content_view_id) { 1 }
  let(:repositories) do
    [
      {'name' => 'repo-1', 'id' => 1},
      {'name' => 'repo-2', 'id' => 2},
      {'name' => 'repo-3', 'id' => 3}
    ]
  end
  let(:repo_ids) { repositories.map { |repo| repo['id'] } }
  let(:repo_names) { repositories.map { |repo| repo['name'] } }

  it 'creates a content-view filter with repository ids' do
    ids = repo_ids.join(',')
    params = %W(--repository-ids=#{ids})

    api_expects(:content_view_filters, :create, 'Create content-view filter')
      .with_params('name' => filter_name, 'repository_ids' => repo_ids.map(&:to_s))
      .returns({})

    expected_result = success_result("Filter created\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end

  it 'creates a content-view filter with repository names' do
    params = %W(--repositories=#{repo_names.join(',')} --product-id 3)

    expect_generic_repositories_search({'names' => repo_names, 'product_id' => 3}, repositories)

    api_expects(:content_view_filters, :create, "Create content-view filter")
      .with_params('name' => filter_name, 'repository_ids' => repo_ids, 'type' => 'rpm')

    expected_result = success_result("Filter created\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end

  it 'should fail with no product specified' do
    ids = repo_ids.join(',')
    params = ["--repositories=#{ids}", "--name=#{filter_name}", \
              "--content-view-id=#{content_view_id}", "--type=rpm"]
    result = run_cmd(@cmd + params)
    assert(result.err[/--product-id, --product is required/])
  end
end
