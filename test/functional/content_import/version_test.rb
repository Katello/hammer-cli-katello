require File.join(File.dirname(__FILE__), '../../test_helper')
require 'hammer_cli_katello/content_import'

describe 'content-import version' do
  include ForemanTaskHelpers

  before do
    @cmd = %w(content-import version)
  end

  let(:task_id) { '5' }

  let(:response) do
    {
      'id' => task_id,
      'state' => 'planned'
    }
  end

  let(:path) do
    File.dirname(__FILE__)
  end

  let(:metadata) do
    JSON.parse(File.read("#{path}/metadata.json"))
  end

  let(:content_view_id) { 3 }

  it "performs import with required options and async" do
    params = [
      "--content-view-id=#{content_view_id}",
      "--path=#{path}",
      '--async'
    ]
    api_expects(:content_imports, :version)
      .with_params('content_view_id' => content_view_id, 'path' => path, 'metadata' => metadata)
      .returns(response)

    result = run_cmd(@cmd + params)

    assert_equal("Archive is being imported in task #{task_id}.\n", result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs import with required options" do
    params = [
      "--content-view-id=#{content_view_id}",
      "--path=#{path}"
    ]

    api_expects(:content_imports, :version)
      .with_params('content_view_id' => content_view_id, 'path' => path, 'metadata' => metadata)
      .returns(response)

    expect_foreman_task(task_id)

    result = run_cmd(@cmd + params)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'fails on missing required params' do
    params = [
      '--id=2'
    ]

    result = run_cmd(@cmd + params)
    expected_error = "Could not import the archive."

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_equal(result.err[/#{expected_error}/], expected_error)
  end

  it 'fails on missing metadata.json' do
    bad_path = "/nosuchdir"
    params = [
      "--content-view-id=#{content_view_id}",
      "--path=#{bad_path}"
    ]
    result = run_cmd(@cmd + params)
    expected_error = "Unable to find '#{bad_path}/metadata.json'."

    assert_match(/#{expected_error}/, result.err)
  end
end
