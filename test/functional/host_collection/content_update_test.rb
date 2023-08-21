require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe 'update Content on a host-collection' do
    { "package" => "katello_package_update",
      "package-group" => "katello_group_update"
     }.each do |command, feature|
      it "errors out on #{command} update" do
        cmd = ["host-collection", command, "update"]
        params = ["--help"]
        result = run_cmd(cmd + params)
        assert_exit_code_equal(HammerCLI::EX_UNAVAILABLE, result.exit_code)
        assert_match(/Not supported. Use the remote execution equivalent/, result.out)
        assert_match(/feature #{feature}/, result.out)
        assert_match(/Specify the host collection with the --search-query/, result.out)
      end
    end
  end
end
