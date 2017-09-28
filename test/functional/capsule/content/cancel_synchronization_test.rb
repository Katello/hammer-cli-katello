require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), './capsule_content_helpers')

describe 'capsule content cancel-synchronization' do
  include CapsuleContentHelpers

  before do
    @cmd = ['capsule', 'content', 'cancel-synchronization']
  end

  MESSAGE = "There's no running synchronization for this capsule.".freeze

  it "triggers the cancel" do
    expected_result = success_result("#{MESSAGE}\n")
    params = ['--id=3']

    ex = api_expects(:capsule_content, :cancel_sync, 'Cancel sync') do |par|
      par['id'] == 3
    end
    ex.returns("message" => MESSAGE)

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "resolves id from name" do
    params = ['--name=capsule1']

    ex = api_expects(:capsule_content, :cancel_sync, 'Cancel sync') do |par|
      par['id'] == 3
    end
    ex.returns("message" => MESSAGE)
    expect_capsule_search('capsule1', 3)

    run_cmd(@cmd + params)
  end

  it "is mounted under proxy too" do
    result = run_cmd(['proxy', 'content', 'cancel-synchronization', '-h'])
    assert_exit_code_equal(HammerCLI::EX_OK, result.exit_code)
  end
end
