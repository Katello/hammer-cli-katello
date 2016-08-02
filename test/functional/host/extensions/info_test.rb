require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'host info' do
  before do
    @cmd = %w(host info)
  end

  it "includes katello attributes" do
    params = ['--id', '1']
    ex = api_expects(:hosts, :show, 'Host show') do |par|
      par['id'] == '1'
    end

    json_file = File.join(File.dirname(__FILE__), 'data', 'host.json')
    ex.returns(JSON.parse(File.read(json_file)))

    result = run_cmd(@cmd + params)

    expected_fields = [['Lifecycle Environment', 'Library'],
                       ['Content View', 'Default Organization View'],
                       ['Release Version', '7Server'],
                       ['Bug Fix', '0'],
                       ['Name', 'my host collection']]
    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected|  assert_cmd(expected, result) }
  end
end
