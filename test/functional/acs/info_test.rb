require File.join(File.dirname(__FILE__), '../test_helper')
require 'hammer_cli_katello/associating_commands'

describe 'get acs info' do
  before do
    @cmd = %w(alternate-content-source info)
  end

  it 'shows acs info by id' do
    params = ['--id=1']
    ex = api_expects(:alternate_content_sources, :show, 'Get info')
    ex.returns(
      'id' => 1,
      'name' => 'Pizza ACS',
      'label' => 'Pizza ACS',
      'base_url' => 'https://proxy.example.com',
      'content_type' => 'yum',
      'alternate_content_source_type' => 'custom',
      'subpaths' => [
        'test/repo1'
      ],
      'smart_proxies' => {
        'id' => 1,
        'name' => 'centos7.example.com',
        'url' => 'https://centos7.example.com:9090',
        'download_policy' => 'on_demand'
      }
    )
    result = run_cmd(@cmd + params)
    # rubocop:disable Style/WordArray
    expected_fields = [['ID', '1'],
                       ['Name', 'Pizza ACS'],
                       ['Label', 'Pizza ACS'],
                       ['Base URL', 'https://proxy.example.com'],
                       ['Content type', 'yum'],
                       ['Alternate content source type', 'custom'],
                       ['Subpaths', ''],
                       ['', 'test/repo1'],
                       ['Smart proxies', ''],
                       ['Id', '1'],
                       ['Name', 'centos7.example.com'],
                       ['URL', 'https://centos7.example.com:9090'],
                       ['Download policy', 'on_demand']]

    # rubocop:enable Style/WordArray
    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected|  assert_cmd(expected, result) }
  end

  it 'shows simplified acs info by id' do
    params = ['--id=2']
    ex = api_expects(:alternate_content_sources, :show, 'Get info')
    ex.returns(
      'id' => 2,
      'name' => 'Pizza ACS',
      'label' => 'Pizza ACS',
      'content_type' => 'yum',
      'alternate_content_source_type' => 'simplified',
      'products' => {
        'id' => 999,
        'organization_id' => 9,
        'name' => 'Buttermilk Biscuits',
        'label' => 'Buttermilk_Biscuits'
      },
      'smart_proxies' => {
        'id' => 1,
        'name' => 'centos7.example.com',
        'url' => 'https://centos7.example.com:9090',
        'download_policy' => 'on_demand'
      }
    )
    result = run_cmd(@cmd + params)
    # rubocop:disable Style/WordArray
    expected_fields = [['ID', '2'],
                       ['Name', 'Pizza ACS'],
                       ['Label', 'Pizza ACS'],
                       ['Content type', 'yum'],
                       ['Alternate content source type', 'simplified'],
                       ['Products', ''],
                       ['Id', '999'],
                       ['Organization ID', '9'],
                       ['Name', 'Buttermilk Biscuits'],
                       ['Label', 'Buttermilk_Biscuits'],
                       ['Smart proxies', ''],
                       ['Id', '1'],
                       ['Name', 'centos7.example.com'],
                       ['URL', 'https://centos7.example.com:9090'],
                       ['Download policy', 'on_demand']]

    # rubocop:enable Style/WordArray
    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected|  assert_cmd(expected, result) }
  end
end
