require_relative '../test_helper'
require_relative './organization_helpers'
require 'hammer_cli_katello/organization'
require 'hammer_cli_katello/associating_commands'

describe HammerCLIKatello::Organization::ConfigureCdnCommand do
  include OrganizationHelpers
  before do
    @cmd = %w(organization configure-cdn)
  end

  it 'by updates with the right params' do
    org_id = '100'
    org_label = 'org1'
    ssl_cred_id = '1'
    password = "pass"
    username = "foo"
    url = "https://goo.com"
    upstream_label = "GreatOrg"
    type = 'network_sync'
    params = ["--label=#{org_label}",
              "--url=#{url}",
              "--username=#{username}",
              "--upstream-organization-label=#{upstream_label}",
              "--password=#{password}",
              "--ssl-ca-credential-id=#{ssl_cred_id}",
              "--type=#{type}"
            ]
    expect_organization_search(org_label, org_id, field: 'label')

    api_expects(:organizations, :cdn_configuration) do |par|
      par['id'].to_s == org_id &&
        par['username'] == username &&
        par['url'] == url &&
        par['password'] == password &&
        par['ssl_ca_credential_id'].to_s == ssl_cred_id &&
        par['upstream_organization_label'] == upstream_label &&
        par['type'] == type
    end

    assert_equal(
      0,
      run_cmd(@cmd + params).exit_code
    )
  end
end
