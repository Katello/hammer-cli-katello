require_relative '../../test_helper'
require_relative '../../content_view/content_view_helpers'
require_relative '../../organization/organization_helpers'
require 'hammer_cli_katello/content_view_puppet_module'

module HammerCLIKatello
  describe ContentViewPuppetModule::DeleteCommand do
    include ContentViewHelpers
    include OrganizationHelpers

    def expect_module_destroy(opts)
      api_expects(:content_view_puppet_modules, :destroy).with_params(opts[:params])
    end

    it 'allows minimal options' do
      expect_module_destroy(params: {'content_view_id' => 1, 'id' => 2})

      run_cmd(%w(content-view puppet-module remove --content-view-id 1 --id 2))
    end

    it 'resolves puppet module ID from UUID' do
      expect_generic_search(:content_view_puppet_modules,
                            params: {'uuid' => 'abcd1234', 'content_view_id' => 1},
                            returns: {'id' => 2})
      expect_module_destroy(params: {'content_view_id' => 1, 'id' => 2})

      run_cmd(%w(content-view puppet-module remove --content-view-id 1 --uuid abcd1234))
    end

    it 'resolves content view ID from name' do
      expect_content_view_search('3', 'cv1', 1)
      expect_module_destroy(params: {'content_view_id' => 1, 'id' => 2})

      run_cmd(%w(content-view puppet-module remove --content-view cv1 --organization-id 3 --id 2))
    end

    it 'resolves organization ID from name' do
      expect_organization_search('org3', 3)
      expect_content_view_search(3, 'cv1', 1)
      expect_module_destroy(params: {'content_view_id' => 1, 'id' => 2})

      run_cmd(%w(content-view puppet-module remove --content-view cv1 --organization org3 --id 2))
    end

    it 'resolves organization ID from label' do
      expect_organization_search('org3', 3, field: 'label')
      expect_content_view_search(3, 'cv1', 1)
      expect_module_destroy(params: {'content_view_id' => 1, 'id' => 2})

      run_cmd(%w(content-view puppet-module remove --content-view cv1 --organization-label
                 org3 --id 2))
    end
  end
end
