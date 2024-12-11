require File.join(File.dirname(__FILE__), '../test_helper')

describe 'get flatpak remote info' do
  before do
    @cmd = %w(flatpak-remote info)
  end

  it 'shows flatpak remote info by id' do
    params = ['--id=12']
    ex = api_expects(:flatpak_remotes, :show, 'Get info')
    ex.returns(
      'id' => 12,
      'name' => 'Fedora flatpak',
      'url' => 'https://registry.fedoraproject.org/',
      'username' => nil,
      'token' => nil,
      'seeded' => true,
      'organization_id' => 1,
      'registry_url' => 'https://registry.fedoraproject.org/',
      'organization' => {
        'id' => 1,
        'name' => 'Default Organization',
        'label' => 'Default_Organization'
      }
    )
    result = run_cmd(@cmd + params)
    expected_fields = [['ID', '12'],
                       ['Name', 'Fedora flatpak'],
                       ['URL', 'https://registry.fedoraproject.org/'],
                       ['Registry URL', 'https://registry.fedoraproject.org/'],
                       ['Organization', ''],
                       ['Id', '1'],
                       ['Name', 'Default Organization'],
                       ['Label', 'Default_Organization'],
                       ]

    expected_results = expected_fields.map { |field| success_result(FieldMatcher.new(*field)) }
    expected_results.each { |expected| assert_cmd(expected, result) }
  end
end
