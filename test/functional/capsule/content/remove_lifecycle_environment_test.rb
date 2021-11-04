require_relative '../../test_helper'
require_relative 'capsule_content_helpers'
require_relative '../../lifecycle_environment/lifecycle_environment_helpers'
require_relative '../../organization/organization_helpers'
require 'hammer_cli_katello/capsule'

# rubocop:disable LineLength
module HammerCLIKatello
  module Capsule
    class Content
      describe Content::RemoveLifecycleEnvironmentCommand do
        include CapsuleContentHelpers
        include LifecycleEnvironmentHelpers
        include OrganizationHelpers

        it 'allows minimal options' do
          expect_lifecycle_environment_remove('id' => 1, 'environment_id' => 2)

          run_cmd(%w(capsule content remove-lifecycle-environment --id 1 --lifecycle-environment-id 2))
        end

        it 'resolves environment ID from name' do
          expect_lifecycle_environment_search('3', 'env2', 2)
          expect_lifecycle_environment_remove('id' => 1, 'environment_id' => 2)

          run_cmd(%w(capsule content remove-lifecycle-environment --id 1 --lifecycle-environment env2
                     --organization-id 3))
        end

        it 'resolves organization ID from name' do
          expect_organization_search('org3', 3)
          expect_lifecycle_environment_search(3, 'env2', 2)
          expect_lifecycle_environment_remove('id' => 1, 'environment_id' => 2)

          run_cmd(%w(capsule content remove-lifecycle-environment --id 1 --lifecycle-environment env2
                     --organization org3))
        end
      end
    end
  end
end
# rubocop:enable LineLength
