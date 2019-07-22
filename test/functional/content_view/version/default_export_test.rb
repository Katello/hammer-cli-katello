require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'content-view version export' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(content-view version export-default)
  end

  it "performs export" do
    params = [
      '--export-dir=/tmp/default'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    Dir.expects(:chdir).with('/var/lib/pulp/published/yum/https/repos/').returns(true)
    Dir.expects(:mkdir).with('/tmp/default').returns(0)
    Dir.expects(:chdir).with('/tmp/default').returns(0)

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end
end
