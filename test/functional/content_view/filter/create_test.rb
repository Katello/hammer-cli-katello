require_relative '../../test_helper'
require_relative '../../repository/repository_helpers'

describe 'content-view filter create' do
  include RepositoryHelpers
  before do
    @cmd = %w(content-view filter create)
    @base_params = ["--organization-id=#{org_id}", "--name=#{filter_name}", \
                    "--content-view-id=#{content_view_id}", "--type=rpm"]
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

    ex = api_expects(:content_view_filters, :create, 'Create content-view filter') do |par|
      par['name'] == filter_name && par['repository_ids'] == repo_ids
      true
    end

    ex.returns({})

    expected_result = success_result("Filter created\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end

  it 'creates a content-view filter with repository names' do
    params = %W(--repositories=#{repo_names.join(',')})

    expect_repositories_search(org_id, repo_names, repo_ids)

    api_expects(:content_view_filters, :create, "Create content-view filter") do |par|
      par['name'] == filter_name && par['repository_ids'] == repo_ids &&
        par['type'] == 'rpm'
    end

    expected_result = success_result("Filter created\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end

  it 'should fail with no organization specified' do
    ids = repo_ids.join(',')
    params = ["--repositories=#{ids}", "--name=#{filter_name}", \
              "--content-view-id=#{content_view_id}", "--type=rpm"]
    result = run_cmd(@cmd + params)
    assert(result.err[/--organization-id, --organization, --organization-label is required/])
  end
end
