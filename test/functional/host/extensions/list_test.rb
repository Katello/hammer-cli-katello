require File.join(File.dirname(__FILE__), '../../test_helper')

describe 'host list' do
  before do
    @cmd = %w(host list)
  end

  it "list hosts" do
    ex = api_expects(:hosts, :index, 'Host index')

    json_file = File.join(File.dirname(__FILE__), 'data', 'host_list.json')
    ex.returns(JSON.parse(File.read(json_file)))

    result = run_cmd(@cmd)

    fields = ['CONTENT VIEW ENVIRONMENTS', 'MULTI CONTENT VIEW ENVIRONMENT', 'TRACE STATUS']
    values = ['Library', 'no', 'updated']
    expected_result = success_result(IndexMatcher.new([fields, values]))
    assert_cmd(expected_result, result)
  end
end
