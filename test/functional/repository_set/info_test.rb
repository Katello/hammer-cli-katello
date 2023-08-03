require_relative '../test_helper'
require 'hammer_cli_katello/repository_set'

module HammerCLIKatello
  describe RepositorySetCommand::InfoCommand do
    it 'allows minimal options' do
      api_expects(:repository_sets, :show)
        .with_params('id' => 1)
      assert_success run_cmd(%w[repository-set info --id 1])
    end

    it 'requires repository set options' do
      api_expects_no_call
      assert_failure run_cmd(%w[repository-set info]), /id.*name.*required/
    end
  end
end
