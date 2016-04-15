require_relative '../test_helper'
require 'hammer_cli_katello/id_resolver'

module HammerCLIKatello
  describe IdResolver do
    let(:api) { mock('api') }
    let(:searchables) { mock('searchables') }
    let(:id_resolver) { IdResolver.new api, searchables }
    describe '#repository_ids' do
      before(:each) do
        api.stubs(:resources).returns([])
      end
      it 'accepts repository_ids' do
        id_resolver.repository_ids(
          'option_repository_ids' => [1, 2]
        ).must_equal [1, 2]
      end

      it 'accepts repository_names' do
        id_resolver.stubs(:find_resources).returns(
          [
            {'id' => 1, 'name' => 'repo1'},
            {'id' => 2, 'name' => 'repo2'}
          ]
        )
        id_resolver.repository_ids(
          'option_names' => %w(repo1 repo2)
        ).must_equal [1, 2]
      end
    end
  end
end
