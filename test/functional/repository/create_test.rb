require_relative '../test_helper'

describe "create repository" do
  let(:org_id) { 1 }
  let(:product_id) { 2 }
  let(:name) { "repo1" }
  let(:content_type) { "yum" }

  it 'with basic options' do
    api_expects(:repositories, :create)
      .with_params(
        name: name,
        product_id: product_id,
        content_type: content_type)

    command = %W(repository create --organization-id #{org_id} --product-id #{product_id}
                 --content-type #{content_type} --name #{name})

    assert_equal(0, run_cmd(command).exit_code)
  end

  it 'with ssl options by name' do
    def stub_gpg_key(gpg_key_name)
      gpg_key_index = api_expects(:gpg_keys, :index)
                      .with_params(
                        name: gpg_key_name.to_s,
                        organization_id: 1,
                        per_page: 1000,
                        page: 1)
      gpg_response = File.join(File.dirname(__FILE__), 'data', "#{gpg_key_name}.json")
      gpg_key_index.returns(JSON.parse(File.read(gpg_response)))
    end

    api_expects(:repositories, :create)
      .with_params(
        name: name,
        product_id: product_id,
        ssl_ca_cert_id: 1,
        ssl_client_cert_id: 2,
        ssl_client_key_id: 3,
        content_type: content_type)

    %w(test_cert test_key test_ca).each { |cred| stub_gpg_key(cred) }

    command = %W(repository create --organization-id #{org_id} --product-id #{product_id}
                 --content-type #{content_type} --name #{name} --ssl-client-cert test_cert
                 --ssl-client-key test_key --ssl-ca-cert test_ca)

    assert_equal(0, run_cmd(command).exit_code)
  end

  it 'shows deprecation warning on puppet content type' do
    dep_warning = "Puppet and OSTree will no longer be supported in Katello 3.16\nRepository created.\n" # rubocop:disable LineLength

    api_expects(:repositories, :create)
      .with_params(
        name: name,
        product_id: product_id,
        content_type: "puppet")

    result = run_cmd(%w(repository create --organization-id 1 --product-id 2
                        --content-type puppet --name repo1))

    assert_equal(dep_warning, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end

  it 'shows deprecation warning on ostree content type' do
    dep_warning = "Puppet and OSTree will no longer be supported in Katello 3.16\nRepository created.\n" # rubocop:disable LineLength

    api_expects(:repositories, :create)
      .with_params(
        name: name,
        product_id: product_id,
        content_type: "ostree")

    result = run_cmd(%w(repository create --organization-id 1 --product-id 2
                        --content-type ostree --name repo1))

    assert_equal(dep_warning, result.out)
    assert_equal(HammerCLI::EX_OK, result.exit_code)
  end
end
