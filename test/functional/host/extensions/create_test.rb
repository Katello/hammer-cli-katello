require_relative '../../test_helper'

module HostExtensions
  describe ::HammerCLIForeman::Host::CreateCommand do
    it "uses the hostgroup CV if the user specifies a hostgroup but no CV" do
      ex = api_expects(:hostgroups, :show) do |p|
        p[:id] == 7
      end
      ex.returns('content_view_id' => 4, 'lifecycle_environment_id' => 6)

      api_expects(:hosts, :create) do |p|
        p['host']['content_facet_attributes']['content_view_id'] == 4 &&
          p['host']['content_facet_attributes']['lifecycle_environment_id'] == 2
      end

      run_cmd(%w(host create --organization-id 1 --hostgroup-id 7 --location-id 1
                 --mac 52:54:00:42:c4:d9 --medium-id 1 --name host1 --lifecycle-environment-id 2))
    end

    it "uses the hostgroup LE if the user specifies a hostgroup but no LE" do
      ex = api_expects(:hostgroups, :show) do |p|
        p[:id] == 7
      end
      ex.returns('content_view_id' => 4, 'lifecycle_environment_id' => 6)

      api_expects(:hosts, :create) do |p|
        p['host']['content_facet_attributes']['content_view_id'] == 3 &&
          p['host']['content_facet_attributes']['lifecycle_environment_id'] == 6
      end

      run_cmd(%w(host create --organization-id 1 --hostgroup-id 7 --location-id 1
                 --mac 52:54:00:42:c4:d9 --medium-id 1 --name host1 --content-view-id 3))
    end
  end
end
