require_relative '../test_helper'
require 'hammer_cli_katello/organization'
require 'hammer_cli_katello/associating_commands'

describe HammerCLIKatello::Organization::InfoCommand do
  before do
    @cmd = %w(organization info)
  end

  let(:cdn_configuration) do
    { "type" => 'network_sync' }
  end

  it "includes simple content access attributes" do
    org_id = 2
    params = ["--id=#{org_id}"]
    api_expects(:organizations, :index).returns(index_response([{'id' => org_id}]))

    api_expects(:organizations, :show)
      .with_params('id' => org_id.to_s)
      .returns("simple_content_access" => true, "id" => org_id,
               "cdn_configuration" => cdn_configuration)
    result = run_cmd(@cmd + params)
    expected = success_result(FieldMatcher.new('Simple Content Access', 'Enabled'))
    assert_cmd(expected, result)
  end

  it "includes cdn configuration attributes" do
    org_id = 2
    params = ["--id=#{org_id}"]
    api_expects(:organizations, :index).returns(index_response([{'id' => org_id}]))

    cdn_configuration = {
      "url" => "https://cdn.redhat.com",
      "type" => "redhat_cdn"
    }

    api_expects(:organizations, :show)
      .with_params('id' => org_id.to_s)
      .returns("cdn_configuration" => cdn_configuration, "id" => org_id)
    result = run_cmd(@cmd + params)
    expected = success_result(FieldMatcher.new('URL', cdn_configuration["url"]))
    assert_cmd(expected, result)
  end
end
