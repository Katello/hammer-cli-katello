require_relative '../test_helper'
require 'hammer_cli_katello/host_collection'

module HammerCLIKatello
  describe HostCollection::UpdateContentBaseCommand do
    it 'updates packages on hosts in a host collection' do
      api_expects(:hosts_bulk_actions, :update_content) do |p|
        p['organization_id'] == 1 &&
          p['included'] == { search: "host_collection_id=\"3\"" } &&
          p['content'] == ['wget']
      end

      run_cmd(%w(host-collection package update --id 3 --packages wget --organization-id 1))
    end

    it 'updates package groups on hosts in a host collection' do
      api_expects(:hosts_bulk_actions, :update_content) do |p|
        p['organization_id'] == 1 &&
          p['included'] == { search: "host_collection_id=\"3\"" } &&
          p['content'] == ['birds']
      end

      run_cmd(%w(host-collection package-group update --id 3
                 --package-groups birds --organization-id 1))
    end
  end
end
