require File.join(File.dirname(__FILE__), '../test_helper')
require File.join(File.dirname(__FILE__), './repository_helpers')
require File.join(File.dirname(__FILE__), '../product/product_helpers')

describe 'Republish a repository' do
  include RepositoryHelpers
  include ForemanTaskHelpers
  include ProductHelpers

  before do
    @cmd = %w(repository republish)
  end

  let(:repo_id) { 1 }
  let(:sync_response) do
    {
      'id' => repo_id.to_s,
      'label' => 'Actions::Katello::Repository::MetadataGenerate',
      'state' => 'planned'
    }
  end

  it "republishes a repository" do
    params = ["--id=#{repo_id}", "--force=true"]

    ex = api_expects(:repositories, :republish, 'Repository republished.') do |par|
      par['id'] == repo_id && par['force'] == true
    end

    ex.returns(sync_response)

    expect_foreman_task('3')

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
  end
end
