require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), './capsule_content_helpers')

describe 'capsule content synchronization_status' do
  include CapsuleContentHelpers

  before do
    @cmd = ['capsule', 'content', 'synchronization-status']
  end

  describe "output" do
    let(:params) { ['--id=3'] }

    before do
      @sync_status = load_json('./data/sync_status.json', __FILE__)
      ex = api_expects(:capsule_content, :sync_status, 'Get sync info') do |par|
        par['id'] == 3
      end
      ex.returns(@sync_status)
    end

    it "shows last sync" do
      expected_result = success_result(FieldMatcher.new("Last sync", "2016/01/10 00:27:51"))

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end

    it "shows last sync time" do
      expected_result = success_result(FieldMatcher.new("Last sync", "2016/01/10 00:27:51"))

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end

    it "shows the proxy status" do
      expected_result = success_result(FieldMatcher.new("Status", "Capsule is synchronized"))

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end

    it "shows environments that can be synchronized" do
      @sync_status['lifecycle_environments'] = [
        load_json('./data/library_env.json', __FILE__)
      ]

      output = FieldMatcher.new("Status", "1 environment(s) can be synchronized: Library")
      expected_result = success_result(output)

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end

    it "shows last sync errors" do
      tasks = load_json('./data/sync_tasks.json', __FILE__)
      @sync_status['last_failed_sync_tasks'] = [
        tasks['failed1'],
        tasks['failed2']
      ]

      output = OutputMatcher.new([
        "Last failure:",
        "    Task id:  ab3e2ae3-fbed-466d-81fc-37130fc9efbb",
        "    Messages:",
        "      404 Resource Not Found"
      ])
      expected_result = success_result(output)

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end

    it "shows currently running tasks" do
      tasks = load_json('./data/sync_tasks.json', __FILE__)
      @sync_status['active_sync_tasks'] = [
        tasks['running']
      ]

      output = OutputMatcher.new([
        "Currently running sync tasks:",
        " 1) Task id:  a484eb0d-b40d-4c4c-b187-bb6291d78652",
        "    Progress: 66%"
      ])
      expected_result = success_result(output)

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end
  end

  it "resolves id from name" do
    params = ['--name=capsule1']

    api_expects(:capsule_content, :sync_status, 'Get sync info') do |par|
      par['id'] == '3'
    end
    expect_capsule_search('capsule1', '3')

    run_cmd(@cmd + params)
  end

  it "is mounted under proxy too" do
    result = run_cmd(['proxy', 'content', 'synchronization-status', '-h'])
    assert_exit_code_equal(HammerCLI::EX_OK, result.exit_code)
  end
end
