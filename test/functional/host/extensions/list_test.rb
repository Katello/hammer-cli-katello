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

  it "list hosts bootc" do
    ex = api_expects(:hosts, :index, 'Host index')

    json_file = File.join(File.dirname(__FILE__), 'data', 'host_list.json')
    ex.returns(JSON.parse(File.read(json_file)))

    result = run_cmd(['host', 'list', "--fields=\"Running image\",\"Running image digest\""])

    fields = ['RUNNING IMAGE', 'RUNNING IMAGE DIGEST']
    values = ['sha256:a68293b8402890ba802f11fc2fab26e23c665be9e645836c3f32cbfe9e07f9ae']
    expected_result = success_result(IndexMatcher.new([fields, values]))
    assert_cmd(expected_result, result)
  end
end
