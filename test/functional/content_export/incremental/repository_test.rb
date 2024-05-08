require_relative '../../test_helper'
require 'hammer_cli_katello/content_export'
require_relative '../../product/product_helpers'
require_relative '../../repository/repository_helpers'
require_relative '../content_export_helpers'

describe 'content-export incremental version' do
  include ForemanTaskHelpers
  include ContentExportHelpers
  include ProductHelpers
  include RepositoryHelpers

  before do
    @cmd = %w(content-export incremental repository)
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

  let(:default_repository_options) do
    {"download_policy" => "immediate", "id" => repository_id}
  end

  let(:product_id) { '77' }
  let(:repository_id) { 100 }

  let(:repo_name) { 'great' }

  it "performs export with required options and async" do
    params = [
      "--id=#{repository_id}",
      '--async'
    ]
    expects_repository(repository_id, default_repository_options)

    ex = api_expects(:content_export_incrementals, :repository)
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
    ex = api_expects(:content_export_incrementals, :repository)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportIncremental::RepositoryCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    result = run_cmd(@cmd + params)
    assert_match(/Generated .*metadata.*json/, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it "performs export with history id" do
    params = [
      "--id=#{repository_id}",
      "--from-history-id=#{export_history_id}"
    ]
    expects_repository(repository_id, default_repository_options)
    api_expects(:content_export_incrementals, :repository)
      .with_params('id' => repository_id,
                   'from_history_id' => export_history_id)
      .returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportIncremental::RepositoryCommand.
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

  it 'correctly resolves product_id and repository name' do
    params = ["--product-id=#{product_id}",
              "--name=#{repo_name}",
              "--async"]
    expects_repository(repository_id, default_repository_options)

    cvv_expect = api_expects(:repositories, :index) do |p|
      assert_equal p['product_id'].to_s, product_id.to_s
      assert_equal p["name"], repo_name
    end

    cvv_expect.at_least_once.
      returns(index_response([{'id' => repository_id}]))

    ex = api_expects(:content_export_incrementals, :repository) do |p|
      assert_equal p['id'], repository_id
    end
    ex.returns(response)
    run_cmd(@cmd + params)
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
    params = ["--product=lol", "--name=#{repo_name}"]
    result = run_cmd(@cmd + params)
    expected_error = "At least one of options --organization-id,"\
                      " --organization, --organization-label is required"

    assert_equal(result.exit_code, HammerCLI::EX_USAGE)
    assert_match(/#{expected_error}/, result.err)
  end

  it 'correctly resolves product_id and repository name' do
    params = ["--product-id=#{product_id}",
              "--name=#{repo_name}",
              "--async"]
    expects_repository(repository_id, default_repository_options)

    cvv_expect = api_expects(:repositories, :index) do |p|
      assert_equal p['product_id'].to_s, product_id.to_s
      assert_equal p["name"], repo_name
    end

    cvv_expect.at_least_once.
      returns(index_response([{'id' => repository_id}]))

    ex = api_expects(:content_export_incrementals, :repository) do |p|
      assert_equal p['id'], repository_id
    end
    ex.returns(response)
    run_cmd(@cmd + params)
  end

  it 'Errors out on lazy repositories' do
    params = ["--id=#{repository_id}"]
    expects_repository(repository_id, "content_type" => 'yum',
                                      "download_policy" => "on_demand",
                                      "id" => repository_id)

    ex = api_expects(:content_export_incrementals, :repository)
    ex.returns(response)

    expect_foreman_task(task_id).at_least_once

    HammerCLIKatello::ContentExportIncremental::RepositoryCommand.
      any_instance.
      expects(:fetch_export_history).
      returns(export_history)

    HammerCLIKatello::ContentExportIncremental::RepositoryCommand.
      any_instance.
      expects(:exit).with(HammerCLI::EX_SOFTWARE)

    result = run_cmd(@cmd + params)
    assert_match(/Unable to fully export this repository because/, result.out)
    assert_match(/#{repository_id}/, result.out)
  end
end
