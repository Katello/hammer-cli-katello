require_relative '../test_helper'

describe 'content-view-environment info' do
  before do
    @cmd = %w(content-view-environment info)
  end

  it 'shows content view environment info by id' do
    params = ['--id=5']
    ex = api_expects(:content_view_environments, :show, 'Get info')
    ex.returns(
      'id' => 5,
      'name' => 'Library/multi_cv',
      'label' => 'Library/multi_cv',
      'default' => false,
      'created_at' => '2026-07-31 12:42:31 UTC',
      'updated_at' => '2026-07-31 13:55:57 UTC',
      'organization' => {
        'id' => 1,
        'name' => 'Default Organization',
        'label' => 'Default_Organization'
      },
      'content_view' => {
        'id' => 4,
        'name' => 'multi_cv',
        'label' => 'multi_cv',
        'default' => false
      },
      'lifecycle_environment' => {
        'id' => 1,
        'name' => 'Library',
        'label' => 'Library',
        'library' => true
      },
      'environment' => {
        'id' => 1,
        'name' => 'Library',
        'label' => 'Library',
        'library' => true
      },
      'activation_keys' => [
        {'id' => 2, 'name' => 'ak1', 'label' => 'ak1'}
      ],
      'activation_keys_count' => 1,
      'hosts_count' => 3,
      'hostgroups' => [
        {'id' => 10, 'name' => 'hg1', 'title' => 'hg1'}
      ],
      'hostgroups_count' => 1
    )

    result = run_cmd(@cmd + params)

    expected_fields = [
      ['Id', '5'],
      ['Name', 'Library/multi_cv'],
      ['Label', 'Library/multi_cv'],
      ['Default', 'no'],
      ['Organization Id', '1'],
      ['Organization', 'Default Organization'],
      ['Content View Id', '4'],
      ['Content View', 'multi_cv'],
      ['Lifecycle Environment Id', '1'],
      ['Lifecycle Environment', 'Library'],
      ['Hosts Count', '3'],
      ['Activation Keys Count', '1'],
      ['Hostgroups Count', '1'],
      ['Activation Keys', ''],
      ['Id', '2'],
      ['Name', 'ak1'],
      ['Label', 'ak1'],
      ['Hostgroups', ''],
      ['Id', '10'],
      ['Name', 'hg1'],
      ['Title', 'hg1']
    ]

    expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
                   .each { |expected| assert_cmd(expected, result) }
  end
end
