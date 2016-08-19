require_relative '../test_helper'
require 'hammer_cli_katello/package'

module HammerCLIKatello
  describe PackageCommand::ListCommand do
    it 'allows minimal options' do
      api_expects(:packages, :index)

      run_cmd(%w(package list))
    end

    describe 'allows organization' do
      it 'name' do
        api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
          .at_least_once.returns(index_response([{'id' => 1}]))

        api_expects(:packages, :index) { |par| par['organization_id'].to_i == 1 }

        run_cmd(%w(package list --organization org1))
      end

      it 'label' do
        api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
          .at_least_once.returns(index_response([{'id' => 1}]))

        api_expects(:packages, :index) { |par| par['organization_id'].to_i == 1 }

        run_cmd(%w(package list --organization-label org1))
      end
    end
  end
end
