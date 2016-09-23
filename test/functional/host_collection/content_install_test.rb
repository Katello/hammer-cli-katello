require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::InstallContentBaseCommand do
    it 'installs packages to hosts in a host collection' do
      api_expects(:hosts_bulk_actions, :install_content) do |p|
        p['organization_id'] == 1 &&
          p['included'] == { search: "host_collection_id=\"3\"" } &&
          p['content'] == ['wget']
      end

      run_cmd(%w(host-collection package install --id 3 --packages wget --organization-id 1))
    end

    it 'installs package groups to hosts in a host collection' do
      api_expects(:hosts_bulk_actions, :install_content) do |p|
        p['organization_id'] == 1 &&
          p['included'] == { search: "host_collection_id=\"3\"" } &&
          p['content'] == ['birds']
      end

      run_cmd(%w(host-collection package-group install --id 3
                 --package-groups birds --organization-id 1))
    end

    it 'installs erratum to hosts in a host collection' do
      api_expects(:hosts_bulk_actions, :install_content) do |p|
        p['organization_id'] == 1 &&
          p['included'] == { search: "host_collection_id=\"3\"" } &&
          p['content'] == ['Bird_Erratum']
      end

      run_cmd(%w(host-collection erratum install --id 3 --errata Bird_Erratum --organization-id 1))
    end
  end
end
