require File.join(File.dirname(__FILE__), '../../test_helper')
require 'hammer_cli_katello/content_export'

describe('content-export generate-listing') do
  include ForemanTaskHelpers

  before do
    @cmd = %w(content-export generate-listing)
    @params = []
    @export_history_id = 100
    @path = '/tmp'
    @export_history = {
      'id' => @export_history_id,
      'path' => @path,
      'metadata' => {'format' => 'syncable'}
    }
    @task_id = SecureRandom.uuid
  end

  let(:cmd) { @cmd + @params }
  let(:result) { run_cmd(cmd) }

  describe('given an export history id') do
    it('loads export history by id') do
      @params = ["--id=#{@export_history_id}"]

      HammerCLIKatello::ContentExport::GenerateListingCommand.
        any_instance.
        expects(:fetch_export_history).
        returns(@export_history)
      assert_match(/Generated/, result.out)
      assert_match(@path, result.out)
    end
  end

  describe('given a task id') do
    it('loads export history based on the task') do
      @params = ["--task-id=#{@task_id}"]

      HammerCLIKatello::ContentExport::GenerateListingCommand.
        any_instance.
        expects(:reload_task).
        returns('id' => 'taskid')

      HammerCLIKatello::ContentExport::GenerateListingCommand.
        any_instance.
        expects(:fetch_export_history).
        returns(@export_history)

      assert_match(/Generated/, result.out)
      assert_match(@path, result.out)
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
