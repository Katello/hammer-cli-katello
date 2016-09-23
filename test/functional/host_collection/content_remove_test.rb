require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::RemoveContentBaseCommand do
    it 'removes packages from hosts in a host collection' do
      api_expects(:hosts_bulk_actions, :remove_content) do |p|
        p['organization_id'] == 1 &&
          p['included'] == { search: "host_collection_id=\"3\"" } &&
          p['content'] == ['wget']
      end

      run_cmd(%w(host-collection package remove --id 3 --packages wget --organization-id 1))
    end

    it 'removes package groups from hosts in a host collection' do
      api_expects(:hosts_bulk_actions, :remove_content) do |p|
        p['organization_id'] == 1 &&
          p['included'] == { search: "host_collection_id=\"3\"" } &&
          p['content'] == ['birds']
      end

      run_cmd(%w(host-collection package-group remove --id 3
                 --package-groups birds --organization-id 1))
    end
  end
end
