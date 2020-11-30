require File.join(File.dirname(__FILE__), '../../../test_helper')
require_relative '../../organization/organization_helpers'
require 'hammer_cli_katello/content_export'

describe 'content-export incremental library' do
  include ForemanTaskHelpers
  include OrganizationHelpers

  before do
    @cmd = %w(content-export incremental library)
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

  let(:export_history_id) { 1000 }

  let(:export_history) do
    {
      "id": export_history_id,
      "path": "/tmp",
      "metadata": {}
    }
  end

  let(:organization_id) { 77 }
  let(:organization_name) { 'Foo' }
  let(:destination_server) { "dream.example.com" }

  it "performs export with required options and async" do
    params = [
      "--organization-id=#{organization_id}",
      '--destination-server=foo',
      '--async'
    ]

    ex = api_expects(:content_export_incrementals, :library)
    ex.returns(response)

    result = run_cmd(@cmd + params)

    assert_equal("Library environment is being exported in task #{task_id}.\n", result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs export with required options" do
    params = [
      "--organization-id=#{organization_id}"
    ]

    ex = api_expects(:content_export_incrementals, :library)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportIncremental::LibraryCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    result = run_cmd(@cmd + params)
    assert_match(/Generated .*metadata.*json/, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs export with history id" do
    params = [
      "--organization-id=#{organization_id}",
      "--destination-server=#{destination_server}",
      "--from-history-id=#{export_history_id}"
    ]
    api_expects(:content_export_incrementals, :library)
      .with_params('organization_id' => organization_id,
                   'destination_server' => destination_server,
                   'from_history_id' => export_history_id)
      .returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportIncremental::LibraryCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    result = run_cmd(@cmd + params)
    assert_match(/Generated .*metadata.*json/, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'fails on missing required params' do
    params = [
      '--id=2'
    ]

    result = run_cmd(@cmd + params)
    expected_error = "Could not export the library:\n"

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_equal(result.err[/#{expected_error}/], expected_error)
  end

  it 'correctly resolves organization id from name' do
    params = ["--organization=#{organization_name}",
              "--async"]

    expect_organization_search(organization_name, organization_id)

    ex = api_expects(:content_export_incrementals, :library) do |p|
      assert_equal p['organization_id'].to_s, organization_id.to_s
    end
    ex.returns(response)

    run_cmd(@cmd + params)
  end
end
