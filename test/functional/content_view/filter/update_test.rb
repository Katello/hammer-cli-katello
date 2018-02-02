require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../content_view_helpers')
require File.join(File.dirname(__FILE__), '../../organization/organization_helpers')

module HammerCLIKatello
  describe 'Filter::UpdateCommand' do
    include ContentViewHelpers
    include OrganizationHelpers

    before do
      @cmd = %w(content-view filter update)
    end

    it 'accepts filter id' do
      params = ['--id=1', '--new-name=valis']

      api_expects(:content_view_filters, :update) do |par|
        par['id'] == 1 && par['name'] == 'valis'
      end

      run_cmd(@cmd + params)
    end

    it 'accepts filter name, content view name, and org name' do
      params = ['--name=scanner', '--content-view=darkly', '--organization=pkd', '--new-name=ubik']

      expect_organization_search('pkd', 1)
      expect_content_view_search(1, 'darkly', 1)

      ex = api_expects(:content_view_filters, :index, 'Content view filters list') do |par|
        par['content_view_id'] == 1 && par['name'] == 'scanner'
      end
      ex.returns(index_response([{'id' => '1'}]))

      api_expects(:content_view_filters, :update) do |par|
        par['id'] == '1' && par['name'] == 'ubik'
      end

      run_cmd(@cmd + params)
    end

    it 'accepts filter name, content view name, and org label' do
      params = ['--name=scanner', '--content-view=darkly',
                '--organization-label=pkd', '--new-name=ubik']

      expect_organization_search('pkd', 1, field: 'label')
      expect_content_view_search(1, 'darkly', 1)

      ex = api_expects(:content_view_filters, :index, 'Content view filters list') do |par|
        par['content_view_id'] == 1 && par['name'] == 'scanner'
      end
      ex.returns(index_response([{'id' => '1'}]))

      api_expects(:content_view_filters, :update) do |par|
        par['id'] == '1' && par['name'] == 'ubik'
      end

      run_cmd(@cmd + params)
    end

    it 'accepts filter name, content view name, and org id' do
      params = ['--name=scanner', '--content-view=darkly', '--organization-id=1', '--new-name=ubik']

      expect_content_view_search('1', 'darkly', 1)

      ex = api_expects(:content_view_filters, :index, 'Content view filters list') do |par|
        par['content_view_id'] == 1 && par['name'] == 'scanner'
      end
      ex.returns(index_response([{'id' => '1'}]))

      api_expects(:content_view_filters, :update) do |par|
        par['id'] == '1' && par['name'] == 'ubik'
      end

      run_cmd(@cmd + params)
    end

    it 'requires content view name or id if name is supplied' do
      params = ["--name=high-castle"]
      expected_result = usage_error_result(
        @cmd,
        'At least one of options --content-view-id, --content-view is required.',
        'Could not update the filter'
      )
      api_expects_no_call
      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end
  end
end
