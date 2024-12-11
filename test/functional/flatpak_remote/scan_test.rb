require File.join(File.dirname(__FILE__), '../test_helper')

describe 'Scan a flatpak remote' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(flatpak-remote scan)
  end

  let(:org_id) { 1 }
  let(:remote_id) { 1 }
  let(:task_id) { 3 }
  let(:scan_response) do
    {
      'id' => remote_id.to_s,
      'state' => 'planned'
    }
  end

  it "scans a repository" do
    params = ["--id=#{remote_id}"]

    ex = api_expects(:flatpak_remotes, :scan, 'Remote is scanned') do |par|
      par['id'] == remote_id
    end

    ex.returns(scan_response)

    expect_foreman_task(task_id)

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 0)
  end
end
