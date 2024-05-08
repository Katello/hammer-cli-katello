require File.join(File.dirname(__FILE__), '../test_helper')

describe 'create alternate content source' do
  before do
    @cmd = %w(alternate-content-source create)
  end

  let(:acs_name) { 'pizza' }
  let(:url) { 'http://proxy.example.com' }
  let(:acs_type) { 'custom' }
  let(:acs_content) { 'yum' }
  let(:verify_ssl) { false }
  let(:proxy_id) { 1 }
  let(:subpaths) { ['test/repo1/'] }

  it 'Creates an ACS' do
    params = ["--name=#{acs_name}", "--alternate-content-source-type=#{acs_type}",
              "--base-url=#{url}", "--content-type=#{acs_content}", "--verify-ssl=#{verify_ssl}",
              "--smart-proxy-ids=#{proxy_id}", "--subpaths=#{subpaths}"]

    api_expects(:alternate_content_sources, :create, 'Create an ACS')

    expected_result = success_result("Alternate Content Source created.\n")
    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
