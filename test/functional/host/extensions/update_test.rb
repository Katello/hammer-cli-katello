require File.join(File.dirname(__FILE__), '../../test_helper')
require 'hammer_cli_foreman/host'

module HammerCLIForeman
  describe Host do
    # These tests are only for the extensions Katello adds to the hostgroup command
    # See hammer-cli-foreman for the core hostgroup tests
    describe UpdateCommand do
      it 'allows kickstart repository name' do
        env_name = "world"
        env_id = 100
        cv_id = 200
        repo_name = "life_of_kickstart"
        repo_id = 111
        host_id = 777
        organization_id = 329
        api_expects(:lifecycle_environments, :index).
          with_params('name' => env_name,
                      'organization_id' => organization_id).
          returns(index_response([{'id' => env_id}]))

        api_expects(:repositories, :index).
          with_params('name' => repo_name,
                      'environment_id' => env_id,
                      'content_view_id' => cv_id).
          returns(index_response([{'id' => repo_id}]))

        api_expects(:hosts, :update).
          with_params('id' => host_id.to_s,
                      'organization_id' => organization_id,
                      'host' => {
                        'compute_attributes' => {},
                        'content_facet_attributes' => {
                          'content_view_id' => cv_id,
                          'lifecycle_environment_id' => env_id,
                          'kickstart_repository_id' => repo_id
                        },
                        'subscription_facet_attributes' => {}
                      })

        cmd = "host update --id=#{host_id}"\
              " --content-view-id=#{cv_id}"\
              " --lifecycle-environment=#{env_name}"\
              " --kickstart-repository=#{repo_name}"\
              " --organization-id=#{organization_id}"
        run_cmd(cmd.split)
      end

      it 'allows content source name' do
        content_source_name = "life_of_cs"
        content_source_id = 111
        host_id = 441

        api_expects(:smart_proxies, :index).
          with_params(:search => "name = \"#{content_source_name}\"").
          returns(index_response([{'id' => content_source_id}]))

        api_expects(:hosts, :update).
          with_params('id' => host_id.to_s,
                      'host' => {
                        'content_facet_attributes' => {
                          'content_source_id' => content_source_id
                        }
                      })

        cmd = "host update --id #{host_id} --content-source #{content_source_name}"
        run_cmd(cmd.split)
      end
    end
  end
end
