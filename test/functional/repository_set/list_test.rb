require_relative '../test_helper'
require 'hammer_cli_katello/repository_set'

module HammerCLIKatello
  describe RepositorySetCommand::ListCommand do
    it 'allows minimal options' do
      api_expects(:repository_sets, :index)
        .with_params('organization_id' => 1)
        .returns(index_response([]))
      assert_success run_cmd(%w(repository-set list --organization-id 1))
    end

    it 'requires organization options' do
      api_expects_no_call
      assert_failure run_cmd(%w(repository-set list)), /organization.*required/
    end
  end
end
