require_relative '../test_helper'

describe 'content-view create' do
  before do
    @cmd = %w(content-view create)
    @base_params = ["--organization-id=#{org_id}", "--name=#{cv_name}"]
  end
  let(:error_heading) { "Could not create the content view" }
  let(:cv_name) { 'test-cv' }
  let(:org_id) { 1 }
  let(:repositories) do
    [
      {'id' => '1'},
      {'id' => '2'},
      {'id' => '3'}
    ]
  end

  it 'creates the content view with repositories specified by ids' do
    wanted = repositories.take(2)
    ids = wanted.map { |repo| repo['id'] }
    params = %W(--repository-ids=#{ids.join(',')})

    api_expects(:content_views, :create, 'Create content view') do |par|
      par['name'] == cv_name &&
        par['repository_ids'] == ids &&
        par['organization_id'] == org_id
    end

    expected_result = success_result("Content view created.\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end
end
