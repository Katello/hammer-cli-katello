require_relative '../test_helper'
require 'hammer_cli_katello/id_resolver'

module HammerCLIKatello
  describe IdResolver do
    let(:api) { mock('api') }
    let(:searchables) { mock('searchables') }
    let(:id_resolver) { IdResolver.new api, searchables }

    before(:each) do
      api.stubs(:resources).returns([])
    end

    describe '#repository_ids' do
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

    describe '#repository_id' do
      it 'resolves ID from name' do
        id_resolver.expects(:find_resource).with(:repositories, name: 'repo1').returns('id' => 5)
        options = {name: 'repo1'}
        id_resolver.repository_id(options).must_equal 5
      end
    end
  end
end
