require File.join(File.dirname(__FILE__), '../../../test_helper')
require 'hammer_cli_katello/content_export_complete'
require_relative '../../product/product_helpers'
require_relative '../../repository/repository_helpers'
require_relative '../content_export_helpers'

describe 'content-export complete repository' do
  include ForemanTaskHelpers
  include ContentExportHelpers
  include ProductHelpers
  include RepositoryHelpers

  before do
    @cmd = %w[content-export complete repository]
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

  let(:default_repository_options) do
    {"download_policy" => "immediate", "id" => repository_id}
  end

  let(:product_id) { '77' }
  let(:repository_id) { '1001' }

  let(:name) { 'repo' }

  it "performs export with required options and async" do
    params = [
      "--id=#{repository_id}",
      '--async'
    ]
    expects_repository(repository_id, default_repository_options)
    ex = api_expects(:content_exports, :repository)
    ex.returns(response)

    result = run_cmd(@cmd + params)

    assert_equal("Repository is being exported in task #{task_id}.\n"\
      + "Once the task completes the export metadata must be generated with the "\
      + "command:\n hammer content-export generate-metadata --task-id #{task_id}\n", result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs export with required options" do
    params = [
      "--id=#{repository_id}"
    ]
    expects_repository(repository_id, default_repository_options)
    ex = api_expects(:content_exports, :repository)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::RepositoryCommand.
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
    expected_error = "Could not export the repository:\n"

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_equal(result.err[/#{expected_error}/], expected_error)
  end

  it 'fails on missing product name/id' do
    params = ["--name=foo"]

    result = run_cmd(@cmd + params)
    expected_error = "At least one of options --product-id, --product is required"

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_match(/#{expected_error}/, result.err)
  end

  it 'fails on missing repository' do
    params = ["--product-id=2"]
    result = run_cmd(@cmd + params)
    expected_error = "--name is required."

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_match(/#{expected_error}/, result.err)
  end

  it 'fails on missing product missing org' do
    params = ["--product=lol", "--name=#{name}"]
    result = run_cmd(@cmd + params)
    expected_error = "At least one of options --organization-id,"\
                        " --organization, --organization-label is required"

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_match(/#{expected_error}/, result.err)
  end

  it 'correctly resolves product_id and repository name' do
    params = ["--product-id=#{product_id}",
              "--name=#{name}",
              "--async"]
    expects_repository(repository_id, default_repository_options)

    cvv_expect = api_expects(:repositories, :index) do |p|
      assert_equal p['product_id'].to_s, product_id.to_s
      assert_equal p["name"], name
    end

    cvv_expect.at_least_once.
      returns(index_response([{'id' => repository_id}]))

    ex = api_expects(:content_exports, :repository) do |p|
      assert_equal p['id'], repository_id
    end
    ex.returns(response)
    run_cmd(@cmd + params)
  end

  it 'correctly resolves chunk-size-gb' do
    chunk_size = 1000
    params = ["--id=#{repository_id}",
              "--chunk-size-gb=#{chunk_size}",
              "--organization-id=99"]

    expects_repository(repository_id, default_repository_options)

    ex = api_expects(:content_exports, :repository) do |p|
      assert_equal p["chunk_size_gb"], chunk_size
    end
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::RepositoryCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    result = run_cmd(@cmd + params)
    assert_match(/Generated .*metadata.*json/, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'fails on invalid chunk-size-gb value' do
    params = ["--id=#{repository_id}",
              "--chunk-size-gb=0.5",
              "--organization-id=99"]

    result = run_cmd(@cmd + params)
    assert_match(/Error: Option '--chunk-size-gb': Numeric value is required/, result.err)
    assert_equal(HammerCLI::EX_USAGE, result.exit_code)
  end

  it 'Errors out on lazy repositories' do
    params = ["--id=#{repository_id}"]
    expects_repository(repository_id, "content_type" => 'yum',
                                      "download_policy" => "on_demand",
                                      "id" => repository_id)

    ex = api_expects(:content_exports, :repository)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::RepositoryCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    HammerCLIKatello::ContentExportComplete::RepositoryCommand.
      any_instance.
      expects(:exit).with(HammerCLI::EX_SOFTWARE)

    result = run_cmd(@cmd + params)
    assert_match(/Unable to fully export this repository because/, result.out)
    assert_match(/#{repository_id}/, result.out)
  end

  it 'should accept product and get the right repository' do
    params = ["--product-id=#{product_id}",
              "--name=#{name}"]
    expect_repository_search(product_id.to_i, name, repository_id).at_least_once
    repo_search = api_expects(:repositories, :index, 'Find a repository') do |p|
      assert_equal p["product_id"].to_s, product_id.to_s
      assert_equal p["name"], name
    end
    repo_search.returns(index_response([{'id' => repository_id}]))

    expects_repository(repository_id, default_repository_options)
    ex = api_expects(:content_exports, :repository)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportComplete::RepositoryCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)
    result = run_cmd(@cmd + params)
    assert_match(/Generated .*metadata.*json/, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end
end
