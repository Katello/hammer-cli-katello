require_relative '../test_helper'
require 'hammer_cli_katello/repository_set'

module HammerCLIKatello
  describe RepositorySetCommand::AvailableRepositoriesCommand do
    it 'allows minimal options' do
      api_expects(:repository_sets, :available_repositories)
        .with_params('id' => 1)
        .returns(index_response([]))
      assert_success run_cmd(%w[repository-set available-repositories --id 1])
    end

    it 'requires repository set options' do
      api_expects_no_call
      assert_failure run_cmd(%w[repository-set available-repositories]), /id.*name.*required/
    end
  end
end
