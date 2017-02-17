require_relative '../test_helper'
require_relative './content_api_expectations'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::UpdateContentBaseCommand do
    include HammerCLIKatello::ContentAPIExpectations

    def api_expects_content_update(content_type, expected_params)
      api_expects_content_action(:update_content, content_type, expected_params)
    end

    it 'updates packages on hosts in a host collection' do
      api_expects_content_update('package', :content => ['wget'])
      run_cmd(%w(host-collection package update --id 3 --packages wget --organization-id 1))
    end

    it 'updates packages on hosts in a host collection specified by name' do
      api_expects_collection_search
      api_expects_content_update('package', :content => ['wget'])
      run_cmd(%w(host-collection package update --name Test --packages wget --organization-id 1))
    end

    it 'updates package groups on hosts in a host collection' do
      api_expects_content_update('package_group', :content => ['birds'])
      run_cmd(%w(host-collection package-group update --id 3
                 --package-groups birds --organization-id 1))
    end

    it 'updates package groups on hosts in a host collection specified by name' do
      api_expects_collection_search
      api_expects_content_update('package_group', :content => ['birds'])
      run_cmd(%w(host-collection package-group update --name Test
                 --package-groups birds --organization-id 1))
    end
  end
end
