require File.join(File.dirname(__FILE__), '../../test_helper')
require 'hammer_cli_katello/content_export'

describe('content-export generate-metadata') do
  include ForemanTaskHelpers

  before do
    @cmd = %w[content-export generate-metadata]
    @params = []
    @export_history_id = 100
    @export_history = {
      'id' => @export_history_id,
      'path' => '/tmp',
      'metadata' => {}
    }
    @task_id = SecureRandom.uuid
  end

  let(:cmd) { @cmd + @params }
  let(:result) { run_cmd(cmd) }

  describe('given an export history id') do
    it('loads export history by id') do
      @params = ["--id=#{@export_history_id}"]

      HammerCLIKatello::ContentExport::GenerateMetadataCommand.
        any_instance.
        expects(:fetch_export_history).
        returns(@export_history)

      expected = success_result("Generated /tmp/metadata.json\n")

      assert_cmd(expected, result)
    end
  end

  describe('given a task id') do
    it('loads export history based on the task') do
      @params = ["--task-id=#{@task_id}"]

      HammerCLIKatello::ContentExport::GenerateMetadataCommand.
        any_instance.
        expects(:reload_task).
        returns('id' => 'taskid')

      HammerCLIKatello::ContentExport::GenerateMetadataCommand.
        any_instance.
        expects(:fetch_export_history).
        returns(@export_history)

      expected = success_result("Generated /tmp/metadata.json\n")

      assert_cmd(expected, result)
    end
  end

  describe('given no arguments') do
    it('tells the user to verify the arguments') do
      expected = "Error: No export history was found. Verify the value given for "\
        + "--task-id or --id\n"
      assert_equal(expected, result.err)
    end
  end
end
