require_relative '../../test_helper'

module HammerCLIKatello
  describe ContentViewVersion::RepublishRepositoriesCommand do
    include ForemanTaskHelpers
    include OrganizationHelpers

    it 'allows republishing repositories on  a content view version' do
      expect_organization_search('org1', 1)

      ex = api_expects(:content_views, :index) do |p|
        p['name'] == 'cv' && p['organization_id'] == 1
      end
      ex.returns(index_response([{'id' => 3}]))

      ex = api_expects(:content_view_versions, :index) do |p|
        p['version'] == '1' && p['content_view_id'] == 3
      end
      ex.returns(index_response([{'id' => 6}]))

      ex = api_expects(:content_view_versions, :republish_repositories) do |p|
        p['id'] == 6
      end
      ex.returns('state' => 'pending', 'id' => '3')

      expect_foreman_task('3')

      result = run_cmd(%w[content-view version republish-repositories --organization org1
                          --content-view cv --version 1 --force true])

      assert_equal(result.exit_code, 0)
    end
  end
end
