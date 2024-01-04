require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), './capsule_content_helpers')

describe 'capsule content info' do
  include CapsuleContentHelpers

  before do
    @cmd = %w(capsule content info)
  end
  let(:params) { ['--id=3'] }

  it "lists content counts" do
    @sync_status = load_json('./data/sync_status.json', __FILE__)
    @sync_status['lifecycle_environments'] = [
      load_json('./data/library_env.json', __FILE__),
      load_json('./data/unsynced_env.json', __FILE__)
    ]

    ex = api_expects(:capsule_content, :sync_status, 'Get sync info') do |par|
      par['id'] == 3
    end
    ex.returns(@sync_status)

    output = OutputMatcher.new([
      "Lifecycle Environments:",
      " 1) Name:          Library",
      "    Organization:  Default Organization",
      "    Content Views:",
      "     1) Name:           Zoo View",
      "        Composite:      no",
      "        Last Published: 2023/10/09 19:18:15",
      "        Repositories:",
      "         1) Repository ID:   2",
      "            Repository Name: Zoo",
      "            Content Counts:",
      "                Packages: 32",
      "                Errata:   4",
      " 2) Name:          Test",
      "    Organization:  Default Organization",
      "    Content Views:",
      "     1) Name:           Zoo View",
      "        Composite:      no",
      "        Last Published: 2023/10/09 19:18:15",
      "        Repositories:",
      "         1) Repository ID:   2",
      "            Repository Name: Zoo",
      "            Content Counts:",
      "                Warning: Content view must be synced to see content counts"
    ])
    expected_result = success_result(output)

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "works with no content counts" do
    @sync_status = load_json('./data/sync_status_no_counts.json', __FILE__)
    @sync_status['lifecycle_environments'] = [
      load_json('./data/library_env.json', __FILE__),
      load_json('./data/unsynced_env.json', __FILE__)
    ]

    ex = api_expects(:capsule_content, :sync_status, 'Get sync info') do |par|
      par['id'] == 3
    end
    ex.returns(@sync_status)

    output = OutputMatcher.new([
      "Lifecycle Environments:",
      " 1) Name:          Library",
      "    Organization:  Default Organization",
      "    Content Views:",
      "     1) Name:           Zoo View",
      "        Composite:      no",
      "        Last Published: 2023/10/09 19:18:15",
      "        Repositories:",
      "         1) Repository ID:   2",
      "            Repository Name: Zoo",
      "            Content Counts:",
      "                Warning: Content view must be synced to see content counts",
      " 2) Name:          Test",
      "    Organization:  Default Organization",
      "    Content Views:",
      "     1) Name:           Zoo View",
      "        Composite:      no",
      "        Last Published: 2023/10/09 19:18:15",
      "        Repositories:",
      "         1) Repository ID:   2",
      "            Repository Name: Zoo",
      "            Content Counts:",
      "                Warning: Content view must be synced to see content counts"
    ])
    expected_result = success_result(output)

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "resolves id from name" do
    params = ['--name=capsule1']

    api_expects(:capsule_content, :sync_status, 'Get sync info') do |par|
      par['id'] == 3
    end
    expect_capsule_search('capsule1', 3)

    run_cmd(@cmd + params)
  end

  it "is mounted under proxy too" do
    result = run_cmd(['proxy', 'content', 'info', '-h'])
    assert_exit_code_equal(HammerCLI::EX_OK, result.exit_code)
  end
end
