require File.join(File.dirname(__FILE__), '../test_helper')

describe 'create content-credentials' do
  before do
    @cmd = %w[content-credentials create]
    @base_params = ["--organization-id=#{org_id}", "--name=#{name}"]
  end

  let(:org_id) { 1 }
  let(:name) { 'sslcert' }
  let(:cert) { File.join(File.dirname(__FILE__), 'data', 'test_cert.json') }

  it 'Creates a SSL Content Credential' do
    params = ["--path=#{cert}", '--content-type=cert']

    api_expects(:content_credentials, :create, 'Create a Content Credential')

    expected_result = success_result("Content Credential created.\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end

  it 'Create a GPG Key Content Credential' do
    params = ["--path=#{cert}", '--content-type=gpg_key']

    api_expects(:content_credentials, :create, 'Create a Content Credential')

    expected_result = success_result("Content Credential created.\n")
    result = run_cmd(@cmd + @base_params + params)
    assert_cmd(expected_result, result)
  end
end
