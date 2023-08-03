require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../../content_view/content_view_helpers')
require File.join(File.dirname(__FILE__), '../../organization/organization_helpers')
require File.join(File.dirname(__FILE__),
                  '../../lifecycle_environment/lifecycle_environment_helpers')

describe 'host subscription register' do
  include OrganizationHelpers
  include ContentViewHelpers
  include LifecycleEnvironmentHelpers

  before do
    @cmd = %w[host subscription register]
  end

  it "subscribe a host" do
    params = ['--name=trump.wall.com', '--content-view-id=1', '--lifecycle-environment-id=2']
    ex = api_expects(:host_subscriptions, :create, 'Host subscription register') do |par|
      par['name'] == 'trump.wall.com' && par['content_view_id'] == 1 &&
        par['lifecycle_environment_id'] == 2
    end
    ex.returns({})

    expected_result = success_result(
      'Host successfully registered.
'
    )

    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end

  it "resolves ids from names" do
    params = ['--name=trump.wall.com', '--content-view=someview', '--lifecycle-environment=someenv',
              '--organization=trumporg']

    api_expects(:host_subscriptions, :create, 'Host subscription register') do |par|
      par['name'] == 'trump.wall.com' && par['content_view_id'] == 1 &&
        par['lifecycle_environment_id'] == 2
    end

    expect_organization_search('trumporg', 3)
    expect_content_view_search(3, 'someview', 1)
    expect_lifecycle_environment_search(3, 'someenv', 2)

    expected_result = success_result(
      'Host successfully registered.
'
    )
    result = run_cmd(@cmd + params)
    assert_cmd(expected_result, result)
  end
end
