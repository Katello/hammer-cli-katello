require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'content-view version export' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(content-view version export)
  end

  it "performs export" do
    params = [
      '--id=5',
      '--export-dir=/tmp/exports'
    ]

    ex = api_expects(:content_view_versions, :show)
    ex.returns(
      'id' => '5',
      'repositories' => [{'id' => '2'}],
      'major' => 1,
      'minor' => 0,
      'content_view' => {'name' => 'cv'},
      'content_view_id' => 4321
    )

    ex = api_expects(:content_views, :show)
    ex.returns(
      'id' => '4321',
      'composite' => false,
      'label' => 'cv'
    )

    ex = api_expects(:repositories, :show).with_params('id' => '2')
    ex.returns(
      'id' => '2',
      'label' => 'Test_Repo',
      'content_type' => 'yum',
      'backend_identifier' => 'Default_Organization-Library-Test_Repo',
      'relative_path' => 'Default_Organization/Library/Test_Repo',
      'library_instance_id' => '1'
    )

    api_expects(:repositories, :show).with_params('id' => '1').returns(
      'id' => '1',
      'download_policy' => 'immediate'
    )
    api_expects(:packages, :index).returns('results' => [])
    api_expects(:errata, :index).returns('results' => [])

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    Dir.expects(:chdir).with("/var/lib/pulp/published/yum/https/repos/").returns(true)
    Dir.expects(:mkdir).with('/tmp/exports/export-cv-5').returns(0)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-cv-5').returns(0)

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs composite export" do
    params = [
      '--id=999',
      '--export-dir=/tmp/exports'
    ]

    ex = api_expects(:content_view_versions, :show)
    ex.returns(
      'id' => '999',
      'repositories' => [{'id' => '2'}],
      'major' => 1,
      'minor' => 0,
      'content_view' => {'name' => 'cv'},
      'content_view_id' => 4321
    )

    ex = api_expects(:content_views, :show)
    ex.returns(
      'id' => '4321',
      'composite' => true,
      'components' => [{ 'name' => "injera 95.5" }, {'name' => 'carrot wot 87.0'}],
      'label' => 'cv'
    )

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    Dir.expects(:chdir).with("/var/lib/pulp/published/yum/https/repos/").never
    Dir.expects(:mkdir).with('/tmp/exports/export-cv-999').returns(0)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-cv-999').returns(0)

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "fails export if any repository is set to background" do
    params = [
      '--id=5',
      '--export-dir=/tmp/exports'
    ]

    ex = api_expects(:content_view_versions, :show)
    ex.returns(
      'id' => '5',
      'repositories' => [{'id' => '2'}],
      'major' => 1,
      'minor' => 0,
      'content_view' => {'name' => 'cv'},
      'content_view_id' => 4321
    )

    ex = api_expects(:content_views, :show)
    ex.returns(
      'id' => '4321',
      'composite' => false
    )

    ex = api_expects(:repositories, :show).with_params('id' => '2')
    ex.returns(
      'id' => '2',
      'label' => 'Test_Repo',
      'content_type' => 'yum',
      'backend_identifier' => 'Default_Organization-Library-Test_Repo',
      'relative_path' => 'Default_Organization/Library/Test_Repo',
      'library_instance_id' => '1'
    )

    api_expects(:repositories, :show).with_params('id' => '1').returns(
      'id' => '1',
      'download_policy' => 'background'
    )

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_SOFTWARE, result.exit_code)
  end

  it "fails export if any repository is set to on_demand" do
    params = [
      '--id=5',
      '--export-dir=/tmp/exports'
    ]

    ex = api_expects(:content_view_versions, :show)
    ex.returns(
      'id' => '5',
      'repositories' => [{'id' => '2'}],
      'major' => 1,
      'minor' => 0,
      'content_view' => {'name' => 'cv'},
      'content_view_id' => 4321
    )

    ex = api_expects(:content_views, :show)
    ex.returns(
      'id' => '4321',
      'composite' => false
    )

    ex = api_expects(:repositories, :show).with_params('id' => '2')
    ex.returns(
      'id' => '2',
      'label' => 'Test_Repo',
      'content_type' => 'yum',
      'backend_identifier' => 'Default_Organization-Library-Test_Repo',
      'relative_path' => 'Default_Organization/Library/Test_Repo',
      'library_instance_id' => '1'
    )

    api_expects(:repositories, :show).with_params('id' => '1').returns(
      'id' => '1',
      'download_policy' => 'on_demand'
    )

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_SOFTWARE, result.exit_code)
  end

  it "fails export if any repository is not yum" do
    params = [
      '--id=5',
      '--export-dir=/tmp/exports'
    ]

    ex = api_expects(:content_view_versions, :show)
    ex.returns(
      'id' => '5',
      'repositories' => [{'id' => '2'}],
      'major' => 1,
      'minor' => 0,
      'content_view' => {'name' => 'cv'},
      'content_view_id' => 4321
    )

    ex = api_expects(:content_views, :show)
    ex.returns(
      'id' => '4321',
      'composite' => false
    )

    ex = api_expects(:repositories, :show).with_params('id' => '2')
    ex.returns(
      'id' => '2',
      'label' => 'Test_Repo',
      'content_type' => 'file',
      'backend_identifier' => 'Default_Organization-Library-Test_Repo',
      'relative_path' => 'Default_Organization/Library/Test_Repo',
      'library_instance_id' => '1'
    )

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 70)
  end
end
