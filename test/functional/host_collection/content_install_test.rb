require_relative '../test_helper'
require_relative './content_api_expectations'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::InstallContentBaseCommand do
    include HammerCLIKatello::ContentAPIExpectations

    def api_expects_content_install(content_type, expected_params)
      api_expects_content_action(:install_content, content_type, expected_params)
    end

    it 'installs packages to hosts in a host collection' do
      api_expects_content_install('package', :content => ['wget'])
      run_cmd(%w(host-collection package install --id 3 --packages wget --organization-id 1))
    end

    it 'installs packages to hosts in a host collection specified by name' do
      api_expects_collection_search
      api_expects_content_install('package', :content => ['wget'])
      run_cmd(%w(host-collection package install --name Test --packages wget --organization-id 1))
    end

    it 'installs package groups to hosts in a host collection' do
      api_expects_content_install('package_group', :content => ['birds'])
      run_cmd(%w(host-collection package-group install --id 3
                 --package-groups birds --organization-id 1))
    end

    it 'installs package groups to hosts in a host collection specified by name' do
      api_expects_collection_search
      api_expects_content_install('package_group', :content => ['birds'])
      run_cmd(%w(host-collection package-group install --name Test
                 --package-groups birds --organization-id 1))
    end

    it 'installs package groups to hosts in a host collection' do
      api_expects_content_install('package_group', :content => ['birds'])
      run_cmd(%w(host-collection package-group install --id 3
                 --package-groups birds --organization-id 1))
    end

    it 'installs package groups to hosts in a host collection specified by name' do
      api_expects_collection_search
      api_expects_content_install('package_group', :content => ['birds'])
      run_cmd(%w(host-collection package-group install --name Test
                 --package-groups birds --organization-id 1))
    end

    it 'installs erratum to hosts in a host collection' do
      api_expects_content_install('errata', :content => ['Bird_Erratum'])
      run_cmd(%w(host-collection erratum install --id 3 --errata Bird_Erratum --organization-id 1))
    end

    it 'installs erratum to hosts in a host collection specified by name' do
      api_expects_collection_search
      api_expects_content_install('errata', :content => ['Bird_Erratum'])
      run_cmd(%w(host-collection erratum install --name Test --errata Bird_Erratum
                 --organization-id 1))
    end
  end
end
