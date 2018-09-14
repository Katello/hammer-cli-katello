require File.join(File.dirname(__FILE__), '../test_helper')

describe 'local helper' do
  before do
    class SuperLocalTestHelper
      def parse_subcommand
        true
      end
    end

    class LocalTestHelper < SuperLocalTestHelper
      include HammerCLIKatello::LocalHelper
    end

    @local_helper = LocalTestHelper.new
  end

  it "does not fail if /usr/share/foreman exists" do
    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    assert @local_helper.parse_subcommand
  end

  it "fails if /usr/share/foreman does not exist" do
    File.expects(:exist?).with('/usr/share/foreman').returns(false)

    assert_raises RuntimeError do
      @local_helper.parse_subcommand
    end
  end
end
