require File.join(File.dirname(__FILE__), '../test_helper')

describe 'create flatpak remote' do
  before do
    @cmd = %w(flatpak-remote create)
  end

  let(:remote_name) { 'pizza' }
  let(:url) { 'http://proxy.example.com' }
  let(:organization_id) { 1 }

  it 'Creates a flatpak remote' do
    params = ["--name=#{remote_name}", "--url=#{url}",
              "--organization-id=#{organization_id}"]

    api_expects(:flatpak_remotes, :create, 'Create a Flatpak remote')

    expected_result = success_result("Flatpak Remote created.\n")
    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
