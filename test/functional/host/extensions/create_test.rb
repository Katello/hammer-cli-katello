require File.join(File.dirname(__FILE__), '../../test_helper')
require 'hammer_cli_foreman/host'

module HammerCLIForeman
  describe Host do
    # These tests are only for the extensions Katello adds to the host command
    # See hammer-cli-foreman for the core host tests
    describe CreateCommand do
      let(:env_name) { "world" }
      let(:env_id) { 100 }
      let(:cv_id) { 220 }
      let(:repo_name) { "life_of_kickstart" }
      let(:repo_id) { 12 }
      let(:content_source_name) { "life_of_cs" }
      let(:content_source_id) { 82 }
      let(:host_name) { "mercury" }
      let(:domain_id) { 134 }
      let(:operatingsystem_id) { 103 }
      let(:architecture_id) { 28 }
      let(:partition_table_id) { 243 }
      let(:location_id) { 213 }
      let(:organization_id) { 324 }

      it 'allows kickstart repository name' do
        api_expects(:lifecycle_environments, :index).
          with_params('name' => env_name,
                      'organization_id' => organization_id).
          returns(index_response([{'id' => env_id}]))

        api_expects(:repositories, :index).
          with_params('name' => repo_name,
                      'environment_id' => env_id,
                      'content_view_id' => cv_id).
          returns(index_response([{'id' => repo_id}]))

        api_expects(:hosts, :create).
          with_params('host' => {
                        'name' => host_name,
                        'location_id' => location_id,
                        'organization_id' => organization_id,
                        'operatingsystem_id' => operatingsystem_id,
                        'architecture_id' => architecture_id,
                        'ptable_id' => partition_table_id,
                        'domain_id' => domain_id,
                        'content_facet_attributes' => {
                          'lifecycle_environment_id' => env_id,
                          'content_view_id' => cv_id,
                          'kickstart_repository_id' => repo_id
                        }
                      })

        cmd = "host create --name=#{host_name} --content-view-id=#{cv_id}"\
              " --lifecycle-environment=#{env_name}"\
              " --kickstart-repository=#{repo_name}"\
              " --operatingsystem-id=#{operatingsystem_id}"\
              " --architecture-id=#{architecture_id}"\
              " --organization-id=#{organization_id}"\
              " --partition-table-id=#{partition_table_id}"\
              " --location-id=#{location_id}"\
              " --domain-id=#{domain_id}"
        run_cmd(cmd.split)
      end

      it 'allows content source name' do
        api_expects(:smart_proxies, :index).
          with_params(:search => "name = \"#{content_source_name}\"").
          returns(index_response([{'id' => content_source_id}]))

        api_expects(:hosts, :create).
          with_params('host' => {
                        'name' => host_name,
                        'location_id' => location_id,
                        'organization_id' => organization_id,
                        'operatingsystem_id' => operatingsystem_id,
                        'architecture_id' => architecture_id,
                        'ptable_id' => partition_table_id,
                        'domain_id' => domain_id,
                        'content_facet_attributes' => {
                          'content_source_id' => content_source_id
                        }
                      })

        cmd = "host create --name=#{host_name}"\
              " --content-source=#{content_source_name}"\
              " --operatingsystem-id=#{operatingsystem_id}"\
              " --architecture-id=#{architecture_id}"\
              " --organization-id=#{organization_id}"\
              " --partition-table-id=#{partition_table_id}"\
              " --location-id=#{location_id}"\
              " --domain-id=#{domain_id}"
        run_cmd(cmd.split)
      end
    end
  end
end
