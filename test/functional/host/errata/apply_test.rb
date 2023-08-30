require File.join(File.dirname(__FILE__), '../../test_helper')
describe 'apply an errata' do
  before do
    @cmd = %w(host errata apply)
  end

  it "errors out on errata applies" do
    params = ["--help"]
    expected = "Not supported. Use the remote execution equivalent "\
            "`hammer job-invocation create --feature katello_errata_install`.\n"
    result = run_cmd(@cmd + params)
    assert_exit_code_equal(HammerCLI::EX_UNAVAILABLE, result.exit_code)
    assert_equal expected, result.out
  end
end
