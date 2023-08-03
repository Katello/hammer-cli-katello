require_relative '../../test_helper'
require 'hammer_cli_katello/content_view_version'

module HammerCLIKatello
  describe ContentViewVersion::ListCommand do
    it 'allows minimal options' do
      api_expects(:content_view_versions, :index)

      run_cmd(%w[content-view version list])
    end

    describe 'allows organization' do
      it 'id' do
        api_expects(:content_view_versions, :index) do |p|
          p['organization_id'] == 1
        end

        run_cmd(%w[content-view version list --organization-id 1])
      end

      it 'name' do
        api_expects(:organizations, :index) { |par| par[:search] == "name = \"org1\"" }
          .at_least_once.returns(index_response([{'id' => 1}]))

        api_expects(:content_view_versions, :index) do |p|
          p['organization_id'] == 1
        end

        run_cmd(%w[content-view version list --organization org1])
      end

      it 'label' do
        api_expects(:organizations, :index) { |par| par[:search] == "label = \"org1\"" }
          .at_least_once.returns(index_response([{'id' => 1}]))

        api_expects(:content_view_versions, :index) do |p|
          p['organization_id'] == 1
        end

        run_cmd(%w[content-view version list --organization-label org1])
      end
    end
  end
end
