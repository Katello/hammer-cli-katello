require_relative '../test_helper'
require 'hammer_cli_katello/lifecycle_environment'

module HammerCLIKatello
  describe LifecycleEnvironmentCommand::UpdateCommand do
    it 'allows minimal options' do
      api_expects(:lifecycle_environments, :update) do |p|
        p['new_name'] == 'le3' && p['id'] == 3
      end

      run_cmd(%w(lifecycle-environment update --id 3 --new-name le3))
    end

    it 'allows registry-name-pattern option' do
      api_expects(:lifecycle_environments, :update) do |p|
        p['registry_name_pattern'] == '<%= repository.docker_upstream_name %>' && p['id'] == 3
      end

      run_cmd(%w(lifecycle-environment update --id 3
                 --registry-name-pattern <%=\ repository.docker_upstream_name\ %>))
    end
  end
end
