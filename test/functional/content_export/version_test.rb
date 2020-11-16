require File.join(File.dirname(__FILE__), '../../test_helper')
require 'hammer_cli_katello/content_export'

describe 'content-export version' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(content-export version)
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
      "path": "/tmp",
      "metadata": {}
    }
  end

  it "performs export with required options and async" do
    params = [
      '--id=2',
      '--destination-server=foo',
      '--async'
    ]

    ex = api_expects(:content_exports, :version)
    ex.returns(response)

    result = run_cmd(@cmd + params)

    assert_equal("Content view version is being exported in task #{task_id}.\n", result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs export with required options" do
    params = [
      '--id=2',
      '--destination-server=foo'
    ]

    ex = api_expects(:content_exports, :version)
    ex.returns(response)

    expect_foreman_task(task_id)

    HammerCLIKatello::ContentExport::VersionCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    result = run_cmd(@cmd + params)
    assert_match(%r{Generated /tmp/metadata.json}, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'fails on missing required params' do
    params = [
      '--id=2'
    ]

    result = run_cmd(@cmd + params)
    expected_error = "Could not export the content view version:\n"

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_equal(result.err[/#{expected_error}/], expected_error)
  end
end
