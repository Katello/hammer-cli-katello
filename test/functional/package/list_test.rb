require_relative '../test_helper'
require 'hammer_cli_katello/package'

module HammerCLIKatello
  describe PackageCommand::ListCommand do
    it 'allows minimal options' do
      api_expects(:packages, :index)

      run_cmd(%w(package list))
    end

    describe 'organization options' do
      it 'can be provided by organization ID' do
        api_expects(:packages, :index) do |params|
          params['organization_id'] == 1
        end

        run_cmd(%w(package list --organization-id 1))
      end

      it 'can be provided by organization name' do
        ex = api_expects(:organizations, :index) do |params|
          params[:search] == "name = \"org1\""
        end
        ex.at_least_once.returns(index_response([{'id' => 1}]))

        api_expects(:packages, :index) do |params|
          params['organization_id'] == 1
        end

        run_cmd(%w(package list --organization org1))
      end

      it 'can be provided by organization label' do
        ex = api_expects(:organizations, :index) do |params|
          params[:search] == "label = \"org1\""
        end
        ex.at_least_once.returns(index_response([{'id' => 1}]))

        api_expects(:packages, :index) do |params|
          params['organization_id'] == 1
        end

        run_cmd(%w(package list --organization-label org1))
      end
    end
  end
end
