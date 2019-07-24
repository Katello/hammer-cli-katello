require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'content-view version export' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(content-view version export-default)
  end

  it "performs export with bad SELinux" do
    params = [
      '--export-dir=/tmp/default'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    Dir.expects(:mkdir).with('/tmp/default').returns(0)
    Kernel.expects(:system).with("rsync -aL /var/lib/pulp/published/yum/https/repos/ /tmp/default")

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_CANTCREAT, result.exit_code)
  end

  it "performs export" do
    params = [
      '--export-dir=/tmp/default'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    Dir.expects(:exist?).with('/tmp/default').returns(0)
    Kernel.expects(:system).with("rsync -aL /var/lib/pulp/published/yum/https/repos/ /tmp/default")
          .returns(true)

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end
end
