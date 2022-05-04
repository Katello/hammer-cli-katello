require File.join(File.dirname(__FILE__), '../test_helper')
require 'hammer_cli_katello/associating_commands'

describe 'get acs info' do
  before do
    @cmd = %w(alternate-content-sources info)
  end

  it 'shows acs info by id' do
    params = ['--id=1']
    ex = api_expects(:alternate_content_sources, :show, 'Get info')
    ex.returns(
      'id' => 1,
      'name' => 'Pizza ACS',
      'label' => 'Pizza ACS',
      'base_url' => 'https://proxy.example.com',
      'alternate_content_source_type' => 'custom',
      'content_type' => 'yum',
      'smart_proxies' => {
        'id' => 1,
        'name' => 'centos7.example.com',
        'url' => 'https://centos7.example.com:9090',
        'created_at' => '2022-05-09T17:40:21.007Z',
        'updated_at' => '2022-05-09T17:40:21.007Z',
        'expired_logs' => 0,
        'download_policy' => 'on_demand'
      },
      'subpaths' => [
        'test/repo1'
      ]
    )
    result = run_cmd(@cmd + params)
    # rubocop:disable Style/WordArray
    expected_fields = [['ID', '1'],
                       ['Name', 'Pizza ACS'],
                       ['Label', 'Pizza ACS'],
                       ['Base URL', 'https://proxy.example.com'],
                       ['Alternate content source type', 'custom'],
                       ['Content type', 'yum'],
                       ['Smart proxies', ''],
                       ['Id', '1'],
                       ['Name', 'centos7.example.com'],
                       ['URL', 'https://centos7.example.com:9090'],
                       ['Created at', '2022-05-09T17:40:21.007Z'],
                       ['Updated at', '2022-05-09T17:40:21.007Z'],
                       ['Expired logs', '0'],
                       ['Download policy', 'on_demand'],
                       ['Subpaths', ''],
                       ['', 'test/repo1']]

    # rubocop:enable Style/WordArray
    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected|  assert_cmd(expected, result) }
  end
end
