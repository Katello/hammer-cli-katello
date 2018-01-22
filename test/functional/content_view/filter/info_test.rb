require File.join(File.dirname(__FILE__), '../../test_helper')
require File.join(File.dirname(__FILE__), '../content_view_helpers')
require File.join(File.dirname(__FILE__), '../../organization/organization_helpers')

module HammerCLIKatello
  describe 'Filter::InfoCommand' do
    include ContentViewHelpers
    include OrganizationHelpers

    before do
      @cmd = %w(content-view filter info)
    end

    it 'accepts filter id' do
      params = ['--id=1']

      api_expects(:content_view_filters, :show) do |par|
        par['id'] == 1
      end

      run_cmd(@cmd + params)
    end

    it 'accepts filter name, content view name, and org name' do
      params = ['--name=scanner', '--content-view=darkly', '--organization=pkd']

      expect_organization_search('pkd', 1)
      expect_content_view_search(1, 'darkly', 1)

      ex = api_expects(:content_view_filters, :index, 'Content view filters list') do |par|
        par['content_view_id'] == 1 && par['name'] == 'scanner'
      end
      ex.returns(index_response([{'id' => '1'}]))

      api_expects(:content_view_filters, :show) do |par|
        par['id'] == '1'
      end

      run_cmd(@cmd + params)
    end

    it 'accepts filter name, content view name, and org label' do
      params = ['--name=scanner', '--content-view=darkly', '--organization-label=pkd']

      expect_organization_search('pkd', 1, field: 'label')
      expect_content_view_search(1, 'darkly', 1)

      ex = api_expects(:content_view_filters, :index, 'Content view filters list') do |par|
        par['content_view_id'] == 1 && par['name'] == 'scanner'
      end
      ex.returns(index_response([{'id' => '1'}]))

      api_expects(:content_view_filters, :show) do |par|
        par['id'] == '1'
      end

      run_cmd(@cmd + params)
    end

    it 'accepts filter name, content view name, and org id' do
      params = ['--name=scanner', '--content-view=darkly', '--organization-id=1']

      expect_content_view_search('1', 'darkly', 1)

      ex = api_expects(:content_view_filters, :index, 'Content view filters list') do |par|
        par['content_view_id'] == 1 && par['name'] == 'scanner'
      end
      ex.returns(index_response([{'id' => '1'}]))

      api_expects(:content_view_filters, :show) do |par|
        par['id'] == '1'
      end

      run_cmd(@cmd + params)
    end

    it 'requires organization name or id if content view name is supplied' do
      params = ["--name=high-castle", "--content-view=grasshopper"]
      expected_result = usage_error_result(
        @cmd,
        'At least one of options --organization-id, --organization, --organization-label ' \
        'is required'
      )
      api_expects_no_call
      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end
  end
end
