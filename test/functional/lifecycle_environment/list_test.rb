require_relative '../test_helper'
require 'hammer_cli_katello/lifecycle_environment'

module HammerCLIKatello
  describe LifecycleEnvironmentCommand::ListCommand do
    it 'allows minimal options' do
      api_expects(:lifecycle_environments, :index)

      run_cmd(%w(lifecycle-environment list))
    end

    describe 'allows organization' do
      it 'id' do
        api_expects(:lifecycle_environments, :index) { |p| p['organization_id'] == 1 }

        run_cmd(%w(lifecycle-environment list --organization-id 1))
      end

      it 'name' do
        api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
          .at_least_once.returns(index_response([{'id' => 1}]))

        api_expects(:lifecycle_environments, :index) { |p| p['organization_id'] == 1 }

        run_cmd(%w(lifecycle-environment list --organization org1))
      end

      it 'label' do
        api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
          .at_least_once.returns(index_response([{'id' => 1}]))

        api_expects(:lifecycle_environments, :index) { |p| p['organization_id'] == 1 }

        run_cmd(%w(lifecycle-environment list --organization-label org1))
      end
    end
  end
end
