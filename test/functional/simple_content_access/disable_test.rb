require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'simple-content-access disable' do
  before do
    @cmd = %w(simple-content-access disable)
  end

  let(:organization_id) { 3 }

  it "disables with required options" do
    params = ["--organization-id=#{organization_id}"]

    api_expects(:simple_content_access, :eligible).
      with_params('organization_id' => organization_id).
      returns("simple_content_access_eligible" => true)

    api_expects(:simple_content_access, :disable)
      .with_params('organization_id' => organization_id)
    run_cmd(@cmd + params)
  end

  it 'fails on missing required params' do
    params = []

    result = run_cmd(@cmd + params)
    expected_error = "Could not disable Simple Content Access for this organization"

    assert_equal(result.exit_code, HammerCLI::EX_SOFTWARE)
    assert_equal(result.err[/#{expected_error}/], expected_error)
  end

  it 'fails on non eligible org' do
    params = ["--organization-id=#{organization_id}"]

    api_expects(:simple_content_access, :eligible).
      with_params('organization_id' => organization_id).
      returns("simple_content_access_eligible" => false)

    api_expects(:simple_content_access, :disable)
      .with_params('organization_id' => organization_id).never
    result = run_cmd(@cmd + params)

    expected_error = "Could not disable Simple Content Access for this organization"

    assert_equal(result.exit_code, HammerCLI::EX_SOFTWARE)
    assert_equal(result.err[/#{expected_error}/], expected_error)
  end
end
