require_relative '../test_helper'

describe 'content-view-environment list' do
  before do
    @cmd = %w(content-view-environment list)
  end

  let(:list_fields) do
    ['ID', 'LABEL', 'LIFECYCLE ENVIRONMENT', 'CONTENT VIEW', 'DEFAULT',
     'HOSTS COUNT', 'ACTIVATION KEYS COUNT', 'HOSTGROUPS COUNT', 'ORGANIZATION']
  end

  let(:empty_response) do
    {
      'total' => 0,
      'subtotal' => 0,
      'page' => '1',
      'per_page' => '1000',
      'error' => nil,
      'search' => nil,
      'sort' => {
        'by' => nil,
        'order' => nil
      },
      'results' => []
    }
  end

  let(:content_view_environment_response) do
    {
      'id' => 5,
      'label' => 'Library/multi_cv',
      'default' => false,
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
      'activation_keys_count' => 1,
      'hosts_count' => 3,
      'hostgroups_count' => 2
    }
  end

  it 'lists content view environments with hostgroups count column' do
    ex = api_expects(:content_view_environments, :index, 'List content view environments') do |par|
      par['page'] == 1 && par['per_page'] == 1000
    end

    ex.returns(empty_response)

    result = run_cmd(@cmd)
    expected_result = success_result(IndexMatcher.new([list_fields, []]))
    assert_cmd(expected_result, result)
  end

  it 'lists content view environments and shows hostgroups count values' do
    ex = api_expects(:content_view_environments, :index, 'List content view environments') do |par|
      par['page'] == 1 && par['per_page'] == 1000
    end

    ex.returns(content_view_environment_response)

    values = ['5', 'Library/multi_cv', 'Library', 'multi_cv', 'false', '3', '1', '2', 'Default Organization']
    result = run_cmd(@cmd)
    expected_result = success_result(IndexMatcher.new([values]))
    assert_cmd(expected_result, result)
  end
end
