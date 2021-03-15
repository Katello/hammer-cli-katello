require_relative '../../test_helper'
describe 'CVImportExportHelper' do
  describe 'validate_pulp3_not_enabled' do
    include HammerCLIKatello::CVImportExportHelper
    it 'returns true when the api endpoint does not return a value' do
      api_expects(:content_exports, :api_status)
      assert_equal true, validate_pulp3_not_enabled('fail_msg')
    end

    it 'raises error when the api reports Pulp 3 is enabled' do
      api_expects(:content_exports, :api_status).returns('api_usable' => true)
      assert_raises(RuntimeError, 'fail msg') { validate_pulp3_not_enabled('fail msg') }
    end

    it 'returns nil when the api reports Pulp 3 is not enabled' do
      api_expects(:content_exports, :api_status).returns('api_usable' => false)
      assert_equal nil, validate_pulp3_not_enabled('fail_msg')
    end
  end
end
