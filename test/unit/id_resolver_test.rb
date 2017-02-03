require_relative '../test_helper'
require 'hammer_cli_katello/id_resolver'

module HammerCLIKatello
  describe IdResolver do
    let(:api) { mock('api') }
    let(:searchables) { mock('searchables') }
    let(:id_resolver) { IdResolver.new api, searchables }

    before(:each) do
      api.stubs(:resources).returns([])
      api.stubs(:resource).returns([])
    end

    describe '#repository_ids' do
      it 'accepts nil repository_names' do
        id_resolver.stubs(:find_resources).returns([])
        id_resolver.repository_ids({}).must_equal(nil)
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

    describe '#repository_id' do
      it 'resolves ID from name' do
        id_resolver.expects(:find_resource).with(:repositories, name: 'repo1').returns('id' => 5)
        options = {name: 'repo1'}
        id_resolver.repository_id(options).must_equal 5
      end
    end

    describe '#content_view_version_id' do
      it 'resolves ID from version number' do
        options = {'option_version' => '2.0', 'option_content_view_id' => 4}
        id_resolver.expects(:find_resources)
                   .with(:content_view_versions, options)
                   .returns(['id' => 5])
        id_resolver.content_view_version_id(options).must_equal 5
      end
    end

    describe '#content_view_version_ids' do
      it 'resolves IDs from version numbers' do
        versions = %w(2.0 3.0)
        version_ids = [2, 3]
        response = "{\"id\"=>2},{\"id\"=>3}"
        options = {'option_versions' => versions, 'option_content_view_id' => 4}
        versions.each_with_index do |version, i|
          id_resolver.expects(:content_view_version_id)
                     .with(options.merge('option_version' => version))
                     .returns(['id' => version_ids[i]])
        end
        id_resolver.content_view_version_ids(options).must_equal response
      end
    end
  end
end
