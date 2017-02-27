require_relative '../test_helper'
require_relative './content_api_expectations'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::RemoveContentBaseCommand do
    include HammerCLIKatello::ContentAPIExpectations

    def api_expects_content_remove(content_type, expected_params)
      api_expects_content_action(:remove_content, content_type, expected_params)
    end

    it 'removes packages from hosts in a host collection' do
      api_expects_content_remove('package', :content => ['wget'])
      run_cmd(%w(host-collection package remove --id 3 --packages wget --organization-id 1))
    end

    it 'removes packages from hosts in a host collection specified by name' do
      api_expects_collection_search
      api_expects_content_remove('package', :content => ['wget'])
      run_cmd(%w(host-collection package remove --name Test --packages wget --organization-id 1))
    end

    it 'removes package groups from hosts in a host collection' do
      api_expects_content_remove('package_group', :content => ['birds'])
      run_cmd(%w(host-collection package-group remove --id 3
                 --package-groups birds --organization-id 1))
    end

    it 'removes package groups from hosts in a host collection specified by name' do
      api_expects_collection_search
      api_expects_content_remove('package_group', :content => ['birds'])
      run_cmd(%w(host-collection package-group remove --name Test
                 --package-groups birds --organization-id 1))
    end
  end
end
