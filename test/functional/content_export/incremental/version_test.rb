require File.join(File.dirname(__FILE__), '../../../test_helper')
require 'hammer_cli_katello/content_export'

describe 'content-export incremental version' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(content-export incremental version)
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
  let(:content_view_version_id) { '100' }

  let(:version) { '10.0' }
  let(:destination_server) { "dream.example.com" }

  it "performs export with required options and async" do
    params = [
      '--id=2',
      '--destination-server=foo',
      '--async'
    ]

    ex = api_expects(:content_export_incrementals, :version)
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

    ex = api_expects(:content_export_incrementals, :version)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportIncremental::VersionCommand.
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

    ex = api_expects(:content_export_incrementals, :version) do |p|
      assert_equal p['id'], content_view_version_id
      assert_equal p["destination_server"], destination_server
    end
    ex.returns(response)

    run_cmd(@cmd + params)
  end
end
