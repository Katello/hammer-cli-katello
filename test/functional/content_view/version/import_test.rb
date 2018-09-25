require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'content-view version import' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(content-view version import)
  end

  it "performs import" do
    params = [
      '--export-tar=/tmp/exports/export-2.tar',
      '--organization-id=1'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)

    File.expects(:exist?).with("/tmp/exports/export-2.tar").returns(true)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-2').returns(0)
    File.expects(:read).with("/tmp/exports/export-2/export-2.json").returns(
      JSON.dump(
        'name' => 'Foo View',
        'major' => '5',
        'minor' => '0',
        'repositories' => [{
          'label' => 'foo',
          'rpm_filenames' => ['foo-1.0-1.el7']
        }]
      )
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'Foo View', 'organization_id' => '1')
    ex.returns(
      'results' => [{
        'id' => '5',
        'repositories' => [{'id' => '2', 'label' => 'foo'}],
        'content_view' => {'name' => 'cv'}
      }]
    )

    ex = api_expects(:repositories, :index)
    ex = ex.with_params('organization_id' => '1', 'library' => true)
    ex.returns(
      'results' => [{
        'id' => '2',
        'label' => 'foo'
      }]
    )

    ex = api_expects(:repositories, :sync)
    ex = ex.with_params('id' => '2', 'source_url' => "file:///tmp/exports/export-2/")
    ex.returns('id' => '2', 'state' => 'planned')

    expect_foreman_task('3')

    ex = api_expects(:content_views, :publish)
    ex = ex.with_params(
      'id' => '5',
      'major' => '5',
      'minor' => '0',
      'repos_units' => [{
        'label' => 'foo',
        'rpm_filenames' => ['foo-1.0-1.el7']
      }]
    )
    ex.returns('id' => '2', 'state' => 'planned')

    expect_foreman_task('3')

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "fails import if any repository does not exist" do
    params = [
      '--export-tar=/tmp/exports/export-2.tar',
      '--organization-id=1'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)

    File.expects(:exist?).with("/tmp/exports/export-2.tar").returns(true)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-2').returns(0)
    File.expects(:read).with("/tmp/exports/export-2/export-2.json").returns(
      JSON.dump(
        'name' => 'Foo View',
        'repositories' => ['label' => 'foo']
      )
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'Foo View', 'organization_id' => '1')
    ex.returns(
      'results' => [{
        'id' => '5',
        'repositories' => [{'id' => '2', 'label' => 'foo'}],
        'content_view' => {'name' => 'cv'}
      }]
    )

    ex = api_expects(:repositories, :index)
    ex = ex.with_params('organization_id' => '1', 'library' => true)
    ex.returns([])

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_SOFTWARE, result.exit_code)
  end
end
