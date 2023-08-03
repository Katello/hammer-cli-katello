require_relative '../../test_helper'
require 'hammer_cli_katello/content_view_version'

module HammerCLIKatello
  describe ContentViewVersion::UpdateCommand do
    include OrganizationHelpers
    it 'allows minimal options' do
      ex = api_expects(:content_view_versions, :update).with_params('description' => 'pizza')
      ex.returns('id' => '2', 'description' => 'pizza')

      result = run_cmd(%w[content-view version update --id 2 --description pizza])
      assert_equal(result.exit_code, 0)
    end
  end

  describe 'content view options' do
    it 'allows content view id with one version' do
      ex = api_expects(:content_view_versions, :index)
      ex.returns('id' => '1', 'content_view' => [{'id' => '2'}])

      ex = api_expects(:content_view_versions, :update).with_params('description' => 'pizza')
      ex.returns('id' => '1', 'description' => 'pizza', 'content_view' => [{'id' => '2'}])

      result = run_cmd(%w[content-view version update --description pizza --content-view-id 2])
      assert_equal(result.exit_code, 0)
    end

    it 'allows content view id with multiple versions' do
      ex = api_expects(:content_view_versions, :index)
      ex.returns('id' => '2', 'content_view' => [{'id' => '3'}])

      ex = api_expects(:content_view_versions, :update).with_params('description' => 'pizza')
      ex.returns('id' => '2', 'description' => 'pizza', 'content_view' => [{'id' => '3'}])

      result = run_cmd(%w[content-view version update --description pizza
                          --content-view-id 3 --version 2])
      assert_equal(result.exit_code, 0)
    end

    it 'blocks update without description' do
      ex = api_expects(:content_view_versions, :index)
      ex.returns('id' => '1', 'content_view' => [{'id' => '2'}])

      result = run_cmd(%w[content-view version update --content-view-id 2])
      assert_equal(result.exit_code, 64)
    end
  end
end
