require File.join(File.dirname(__FILE__), '../../../test_helper')
require_relative '../../organization/organization_helpers'
require_relative '../content_export_helpers'
require 'hammer_cli_katello/content_export_complete'

describe 'content-export complete library' do
  include ForemanTaskHelpers
  include OrganizationHelpers
  include ContentExportHelpers

  before do
    @cmd = %w(content-export complete library)
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

  let(:organization_id) { '77' }
  let(:organization_name) { 'Foo' }
  let(:destination_server) { "dream.example.com" }

  it "performs export with required options and async" do
    params = [
      "--organization-id=#{organization_id}",
      '--destination-server=foo',
      '--async'
    ]
    expects_repositories_in_library(organization_id)
    ex = api_expects(:content_exports, :library)
    ex.returns(response)

    result = run_cmd(@cmd + params)

    assert_equal("Library environment is being exported in task #{task_id}.\n"\
      + "Once the task completes the export metadata must be generated with the "\
      + "command:\n hammer content-export generate-metadata --task-id #{task_id}\n", result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs export with required options" do
    params = [
      "--organization-id=#{organization_id}"
    ]
    expects_repositories_in_library(organization_id)
    ex = api_expects(:content_exports, :library)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::LibraryCommand.
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

  it 'fails on empty params' do
    params = []
    result = run_cmd(@cmd + params)
    expected_error = "Could not find organization, please set one of options"

    assert_equal(result.exit_code, HammerCLI::EX_SOFTWARE)
    assert_equal(result.err[/#{expected_error}/], expected_error)
    assert_match(/#{expected_error}/, result.err)
  end

  it 'correctly resolves organization id from name' do
    params = ["--organization=#{organization_name}",
              "--async"]
    expects_repositories_in_library(organization_id)
    expect_organization_search(organization_name, organization_id)

    ex = api_expects(:content_exports, :library) do |p|
      assert_equal p['organization_id'].to_s, organization_id.to_s
    end
    ex.returns(response)

    run_cmd(@cmd + params)
  end

  it 'warns of lazy repositories' do
    params = ["--organization-id=#{organization_id}"]
    expects_repositories_in_library(organization_id, [{id: 200}])

    ex = api_expects(:content_exports, :library)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::LibraryCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    result = run_cmd(@cmd + params)
    assert_match(/Unable to fully export this organization's library/, result.out)
    assert_match(/200/, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'Errors out on lazy repositories if --fail-on-missing-content' do
    params = ["--organization-id=#{organization_id}",
              "--fail-on-missing-content"]
    expects_repositories_in_library(organization_id, [{id: 200}])

    ex = api_expects(:content_exports, :library)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::LibraryCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    HammerCLIKatello::ContentExportComplete::LibraryCommand.
      any_instance.
      expects(:exit).with(HammerCLI::EX_SOFTWARE)

    result = run_cmd(@cmd + params)
    assert_match(/Unable to fully export this organization's library/, result.out)
    assert_match(/200/, result.out)
  end
end
