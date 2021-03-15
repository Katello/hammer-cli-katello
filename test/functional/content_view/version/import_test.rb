require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'content-view version import' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(content-view version import)
  end

  it "performs import" do
    HammerCLIKatello::ContentViewVersion::ImportCommand.any_instance
      .expects(:validate_pulp3_not_enabled).returns(true)
    params = [
      '--export-tar=/tmp/exports/export-2.tar',
      '--organization-id=1'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

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

  it "performs composite import" do
    HammerCLIKatello::ContentViewVersion::ImportCommand.any_instance
      .expects(:validate_pulp3_not_enabled).returns(true)
    params = [
      '--export-tar=/tmp/exports/export-999.tar',
      '--organization-id=1'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    File.expects(:exist?).with("/tmp/exports/export-999.tar").returns(true)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-999').returns(0)
    File.expects(:read).with("/tmp/exports/export-999/export-999.json").returns(
      JSON.dump(
        'name' => 'Foo Composite View',
        'major' => '10',
        'minor' => '0',
        'composite_components' => ["berbere 55.32"]
      )
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'berbere', 'organization_id' => '1')
    ex.returns(
      'results' => [{'versions' => [{'version' => '10.0', 'id' => '654'},
                                    {'version' => '55.32', 'id' => '876'}]
                    }]
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'Foo Composite View', 'organization_id' => '1')
    ex.returns(
      'results' => [{
        'id' => '5',
        'repositories' => [{'id' => '2', 'label' => 'foo'}],
        'content_view' => {'name' => 'cv'}
      }]
    )

    ex = api_expects(:content_views, :update)
    ex = ex.with_params(
      'id' => '5',
      'component_ids' => ['876']
    )
    ex.returns('id' => '5', 'state' => 'planned')

    ex = api_expects(:content_views, :publish)
    ex = ex.with_params(
      'id' => '5',
      'major' => '10',
      'minor' => '0'
    )
    ex.returns('id' => '2', 'state' => 'planned')

    expect_foreman_task('3')

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs composite import, component not found" do
    HammerCLIKatello::ContentViewVersion::ImportCommand.any_instance
      .expects(:validate_pulp3_not_enabled).returns(true)
    params = [
      '--export-tar=/tmp/exports/export-999.tar',
      '--organization-id=1'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    File.expects(:exist?).with("/tmp/exports/export-999.tar").returns(true)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-999').returns(0)
    File.expects(:read).with("/tmp/exports/export-999/export-999.json").returns(
      JSON.dump(
        'name' => 'Foo Composite View',
        'major' => '10',
        'minor' => '0',
        'composite_components' => ["berbere 55.32", "unicorn 99.99"]
      )
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'berbere', 'organization_id' => '1')
    ex.returns(
      'results' => [{'versions' => [{'version' => '10.0', 'id' => '654'},
                                    {'version' => '55.32', 'id' => '876'}]
                    }]
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'unicorn', 'organization_id' => '1')
    ex.returns(
      'results' => []
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'Foo Composite View', 'organization_id' => '1')
    ex.returns(
      'results' => [{
        'id' => '5',
        'repositories' => [{'id' => '2', 'label' => 'foo'}],
        'content_view' => {'name' => 'cv'}
      }]
    )

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_SOFTWARE, result.exit_code)
  end

  it "fails import if cv has not been created" do
    HammerCLIKatello::ContentViewVersion::ImportCommand.any_instance
      .expects(:validate_pulp3_not_enabled).returns(true)
    params = [
      '--export-tar=/tmp/exports/export-2.tar',
      '--organization-id=1'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    File.expects(:exist?).with("/tmp/exports/export-2.tar").returns(true)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-2').returns(0)
    File.expects(:read).with("/tmp/exports/export-2/export-2.json").returns(
      JSON.dump(
        'name' => 'Foo View'
      )
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'Foo View', 'organization_id' => '1')
    ex.returns([])

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_SOFTWARE, result.exit_code)
  end

  it "fails import if repo is set to mirror-on-sync" do
    HammerCLIKatello::ContentViewVersion::ImportCommand.any_instance
      .expects(:validate_pulp3_not_enabled).returns(true)
    params = [
      '--export-tar=/tmp/exports/export-2.tar',
      '--organization-id=1'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    File.expects(:exist?).with("/tmp/exports/export-2.tar").returns(true)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-2').returns(0)
    File.expects(:read).with("/tmp/exports/export-2/export-2.json").returns(
      JSON.dump(
        'name' => 'Foo View',
        'major' => '2',
        'minor' => '1'
      )
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'Foo View', 'organization_id' => '1')
    ex.returns(
      'results' => [{
        'id' => '5',
        'repositories' => [{'id' => '2', 'label' => 'foo', 'mirror_on_sync' => 'true'}],
        'content_view' => {'name' => 'cv'}
      }]
    )

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 70)
  end

  it "fails import if cv version already exists" do
    HammerCLIKatello::ContentViewVersion::ImportCommand.any_instance
      .expects(:validate_pulp3_not_enabled).returns(true)
    params = [
      '--export-tar=/tmp/exports/export-2.tar',
      '--organization-id=1'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    File.expects(:exist?).with("/tmp/exports/export-2.tar").returns(true)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-2').returns(0)
    File.expects(:read).with("/tmp/exports/export-2/export-2.json").returns(
      JSON.dump(
        'name' => 'Foo View',
        'major' => '2',
        'minor' => '1'
      )
    )

    ex = api_expects(:content_views, :index)
    ex = ex.with_params('name' => 'Foo View', 'organization_id' => '1')
    ex.returns(
      'results' => [{
        'id' => '5',
        'content_view' => {'name' => 'cv'},
        'versions' => [{'version' => '2.1', 'id' => '654'}]
      }]
    )

    result = run_cmd(@cmd + params)
    assert_equal(result.exit_code, 70)
  end

  it "fails import if any repository does not exist" do
    HammerCLIKatello::ContentViewVersion::ImportCommand.any_instance
      .expects(:validate_pulp3_not_enabled).returns(true)
    params = [
      '--export-tar=/tmp/exports/export-2.tar',
      '--organization-id=1'
    ]

    File.expects(:exist?).with('/usr/share/foreman').returns(true)
    File.stubs(:exist?).with('/var/log/hammer/hammer.log._copy_').returns(false)

    File.expects(:exist?).with("/tmp/exports/export-2.tar").returns(true)
    Dir.expects(:chdir).with('/tmp/exports').returns(0)
    Dir.expects(:chdir).with('/tmp/exports/export-2').returns(0)
    File.expects(:read).with("/tmp/exports/export-2/export-2.json").returns(
      JSON.dump(
        'name' => 'Foo View',
        'repositories' => ['label' => 'foo'],
        'major' => '2',
        'minor' => '1'
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
