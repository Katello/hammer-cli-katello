require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'simple-content-access status' do
  before do
    @cmd = %w(simple-content-access status)
  end

  let(:organization_id) { 3 }

  it 'list status with required options' do
    params = ["--organization-id=#{organization_id}"]
    api_expects(:simple_content_access, :status).
      with_params('organization_id' => organization_id).
      returns('simple_content_access' => true)

    run_cmd(@cmd + params)
  end

  it 'fails on missing required params' do
    params = []
    result = run_cmd(@cmd + params)
    # rubocop:disable Layout/LineLength
    expected_error = 'Could not find organization, please set one of options --organization-id, --organization, --organization-title, --organization-label.'
    # rubocop:enable Layout/LineLength

    assert_equal(result.exit_code, HammerCLI::EX_SOFTWARE)
    assert_equal(result.err[/#{expected_error}/], expected_error)
  end
end
