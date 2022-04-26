require_relative '../test_helper'
require_relative './repository_set_helpers'
require 'hammer_cli_katello/repository_set'

module HammerCLIKatello
  describe RepositorySetCommand::DisableCommand do
    include RepositorySetHelpers

    it 'allows minimal options' do
      api_expects(:repository_sets, :disable)
        .with_params('id' => 1)
      assert_success run_cmd(%w(repository-set disable --id 1))
    end

    it 'requires repository set options' do
      api_expects_no_call
      assert_failure run_cmd(%w(repository-set disable)), /id.*name.*required/
    end

    describe 'resolves repository set ID' do
      it 'by requiring organization or product options' do
        api_expects_no_call
        assert_failure run_cmd(%w(repository-set disable --name reposet1)),
          /organization.*product.*required/
      end

      it 'from organization options' do
        expect_repository_set_search('reposet1', 1, organization_id: 2)
        api_expects(:repository_sets, :disable)
          .with_params('id' => 1)
        assert_success run_cmd(%w(repository-set disable --name reposet1 --organization-id 2))
      end

      it 'from product options' do
        repo_id = 1001
        product_id = 3
        api_expects(:repositories, :index, 'Find a repository')
          .with_params('product_id' => product_id)
          .returns(index_response([{'id' => repo_id}]))

        expect_repository_set_search('reposet1', 1, product_id: 3)
        api_expects(:repository_sets, :disable)
          .with_params('id' => 1, 'repository_id' => repo_id)
        assert_success run_cmd(%w(repository-set disable --name reposet1 --product-id 3))
      end
    end
  end
end
