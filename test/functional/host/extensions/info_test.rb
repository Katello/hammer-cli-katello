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
    # rubocop:disable Style/WordArray
    expected_fields = [['Name', 'robot.example.com'],
                       ['Release Version', '7Server'],
                       ['Name', 'Rhel 7'],
                       ['Name', 'capsule'],
                       ['Bug Fix', '0'],
                       ['Name', 'my host collection'],
                       ['Applicable Packages', '5'],
                       ['Upgradable Packages', '4'],
                       ['Purpose Usage', 'Production'],
                       ['Purpose Role', 'Role'],
                       ['Trace Status', 'Updated'],
                       ['Running image', 'potato'],
                       ['Running image digest',
                        'sha256:a68293b8402890ba802f11fc2fab26e23c665be9e645836c3f32cbfe9e07f9ae']]
    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected|  assert_cmd(expected, result) }
  end
end
