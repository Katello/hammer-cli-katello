require_relative '../test_helper'

class SearchOptionsCreatorsMock < HammerCLIKatello::IdResolver
  def one
  end

  def two
  end
end

describe HammerCLIKatello::SearchOptionsCreators do
  let(:api) { mock('api') }
  let(:searchables) { HammerCLIKatello::Searchables.new }
  let(:search_options_creators) { SearchOptionsCreatorsMock.new(api, searchables) }
  let(:options) { Hash.new }
  let(:resource) { mock('ApipieBindings::Resource') }

  before(:each) do
    api.stubs(:resources).returns([resource])
    resource.stubs(:singular_name).returns('')
  end

  describe '#create_repository_search_options' do
    it 'handles a repository' do
      search_options_creators.create_repository_search_options(
        'option_name' => 'repo1'
      )['name'].must_equal 'repo1'
    end

    it 'handles an organization_id' do
      search_options_creators.create_repository_search_options(
        'option_organization_id' => 2
      )['organization_id'].must_equal 2
    end
  end

  describe '#create_repositories_search_options' do
    it 'handles an array of names' do
      search_options_creators.create_repositories_search_options(
        'option_names' => ['repo1']
      )['names'].must_equal ['repo1']
    end

    it 'handles a single value name' do
      search_options_creators.create_repositories_search_options(
        'option_name' => 'repo1'
      )['name'].must_equal 'repo1'
    end

    it 'handles a single value product_id' do
      search_options_creators.create_repositories_search_options(
        'option_product_id' => 3
      )['product_id'].must_equal 3
    end

    it 'handles an organization_id' do
      search_options_creators.create_repositories_search_options(
        'option_organization_id' => 4
      )['organization_id'].must_equal 4
    end
  end

  describe '#create_content_view_versions_search_options(options)' do
    it 'handles a single value environment_id' do
      search_options_creators.create_content_view_versions_search_options(
        'option_environment_id' => 3,
        'option_content_view_id' => :required_option
      )['environment_id'].must_equal 3
    end

    it 'handles a single value content_view_id' do
      search_options_creators.create_content_view_versions_search_options(
        'option_content_view_id' => 3
      )['content_view_id'].must_equal 3
    end

    it 'handles a single value version' do
      search_options_creators.create_content_view_versions_search_options(
        'option_version' => 3
      )['version'].must_equal 3
    end
  end

  describe "#create_host_collections_search_options" do
    it 'handles organization options' do
      api.stubs(:resource)
      search_options_creators.stubs(:scoped_options).returns('option_name' => 'org1')
      search_options_creators.expects(:organization_id).with('option_name' => 'org1').returns(1)
      search_options_creators.expects(:create_search_options_with_katello_api)
      search_options_creators.create_host_collections_search_options(
        'option_organization_name' => 'org1'
      )
    end
  end

  describe 'without the katello api' do
    before(:each) do
      search_options_creators.expects(:create_search_options_without_katello_api)
      search_options_creators.stubs(:api).returns(api)
      api.stubs(:resource)
    end

    describe '#create_organizations_search_options(options)' do
      it 'does not use the katello api' do
        search_options_creators.create_organizations_search_options(:anything)
      end
    end

    describe '#create_smart_proxies_search_options(options)' do
      it 'does not use the katello api' do
        search_options_creators.create_organizations_search_options(:anything)
      end
    end

    describe '#create_capsules_search_options(options)' do
      it 'does not use the katello api' do
        search_options_creators.create_organizations_search_options(:anything)
      end
    end

    describe '#create_search_options_with_katello_api(options, resource)' do
      it 'does not use the katello api' do
        search_options_creators.create_organizations_search_options(:anything)
      end
    end
  end # describe 'without the katello api'

  describe '#create_search_options_with_katello_api' do
    it 'translates all searchable fields from options' do
      search_options_creators.stubs(:searchables).
        returns([search_options_creators.method(:one), search_options_creators.method(:two)])

      search_options_creators.create_search_options_with_katello_api(
        {'option_one' => 1, 'option_two' => 2}, resource
      ).must_equal('one' => '1', 'two' => '2')
    end
  end # describe '#create_search_options_with_katello_api'
end # describe HammerCLIKatello::SearchOptionsCreators
