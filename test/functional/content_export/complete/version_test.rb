require File.join(File.dirname(__FILE__), '../../../test_helper')
require 'hammer_cli_katello/content_export_complete'
require_relative '../../lifecycle_environment/lifecycle_environment_helpers'
require_relative '../../content_view/content_view_helpers'
require_relative '../content_export_helpers'

describe 'content-export complete version' do
  include ForemanTaskHelpers
  include ContentExportHelpers
  include ContentViewHelpers
  include LifecycleEnvironmentHelpers

  before do
    @cmd = %w(content-export complete version)
  end

  let(:task_id) { '5' }
  let(:response) do
    {
      'id' => task_id,
      'state' => 'planned',
      'output' => {
        'export_history_id' => 2
      }
    }
  end

  let(:export_history) do
    {
      "id": 1000,
      "path": "/tmp",
      "metadata": {}
    }
  end

  let(:content_view_id) { '77' }
  let(:content_view_version_id) { '1001' }

  let(:version) { '10.0' }
  let(:destination_server) { "dream.example.com" }

  it "performs export with required options and async" do
    params = [
      "--id=#{content_view_version_id}",
      '--destination-server=foo',
      '--async'
    ]
    expects_repositories_in_version(content_view_version_id)
    ex = api_expects(:content_exports, :version)
    ex.returns(response)

    result = run_cmd(@cmd + params)

    assert_equal("Content view version is being exported in task #{task_id}.\n"\
      + "Once the task completes the export metadata must be generated with the "\
      + "command:\n hammer content-export generate-metadata --task-id #{task_id}\n", result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs export with required options" do
    params = [
      "--id=#{content_view_version_id}",
      '--destination-server=foo'
    ]
    expects_repositories_in_version(content_view_version_id)
    ex = api_expects(:content_exports, :version)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::VersionCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    result = run_cmd(@cmd + params)
    assert_match(/Generated .*metadata.*json/, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'fails on missing required params' do
    params = [
      '--boo-id=2'
    ]

    result = run_cmd(@cmd + params)
    expected_error = "Could not export the content view version:\n"

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_equal(result.err[/#{expected_error}/], expected_error)
  end

  it 'fails on missing content-view name/id' do
    params = []

    result = run_cmd(@cmd + params)
    expected_error = "At least one of options --id, --content-view, --content-view-id is required"

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_match(/#{expected_error}/, result.err)
  end

  it 'fails on missing content-view version' do
    params = ["--content-view-id=2"]
    result = run_cmd(@cmd + params)
    expected_error = "--version, --lifecycle-environment-id, --lifecycle-environment is required."

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_match(/#{expected_error}/, result.err)
  end

  it 'fails on missing content-view missing org' do
    params = ["--content-view=lol", "--version=4.0"]
    result = run_cmd(@cmd + params)
    expected_error = "At least one of options --organization-id, "\
                    "--organization, --organization-label is required."

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_match(/#{expected_error}/, result.err)
  end

  it 'correctly resolves content-view-id and content view version number' do
    params = ["--content-view-id=#{content_view_id}",
              "--version=#{version}",
              "--destination-server=#{destination_server}",
              "--async"]

    cvv_expect = api_expects(:content_view_versions, :index) do |p|
      assert_equal p['content_view_id'].to_s, content_view_id.to_s
      assert_equal p["version"], version
    end

    cvv_expect.at_least_once.
      returns(index_response([{'id' => content_view_version_id}]))

    ex = api_expects(:content_exports, :version) do |p|
      assert_equal p['id'], content_view_version_id
      assert_equal p["destination_server"], destination_server
    end
    ex.returns(response)

    expects_repositories_in_version(content_view_version_id)
    run_cmd(@cmd + params)
  end

  it 'warns of lazy repositories' do
    params = ["--id=#{content_view_version_id}"]
    expects_repositories_in_version(content_view_version_id, [{id: 200}])

    ex = api_expects(:content_exports, :version)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::VersionCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    result = run_cmd(@cmd + params)
    assert_match(/Unable to fully export this version because/, result.out)
    assert_match(/200/, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'Errors out on lazy repositories if --fail-on-missing-content' do
    params = ["--id=#{content_view_version_id}",
              "--fail-on-missing-content"]
    expects_repositories_in_version(content_view_version_id, [{id: 200}])

    ex = api_expects(:content_exports, :version)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::VersionCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    HammerCLIKatello::ContentExportComplete::VersionCommand.
      any_instance.
      expects(:exit).with(HammerCLI::EX_SOFTWARE)

    result = run_cmd(@cmd + params)
    assert_match(/Unable to fully export this version because/, result.out)
    assert_match(/200/, result.out)
  end

  it 'should accept content view and lifecycle environment and get the right version' do
    env = "foo"
    org_id = '100'
    env_id = '223'
    params = ["--content-view-id=#{content_view_id}",
              "--lifecycle-environment=#{env}",
              "--organization-id=#{org_id}"]
    expect_lifecycle_environment_search(org_id, env, env_id)
    expect_content_view_version_search({'environment_id' => env_id,
                                        'content_view_id' => content_view_id},
                                       'id' => content_view_version_id).at_least_once

    expects_repositories_in_version(content_view_version_id)
    ex = api_expects(:content_exports, :version)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::VersionCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    result = run_cmd(@cmd + params)
    assert_match(/Generated .*metadata.*json/, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end
end
