require_relative '../test_helper'
require 'hammer_cli_katello/lifecycle_environment'

module HammerCLIKatello
  describe LifecycleEnvironmentCommand::CreateCommand do
    it 'allows minimal options' do
      api_expects(:lifecycle_environments, :create) do |p|
        p['name'] == 'le1' && p['prior_id'] == '3' && p['organization_id'] == 1
      end

      run_cmd(%w(lifecycle-environment create --name le1 --prior-id 3 --organization-id 1))
    end
  end
end
