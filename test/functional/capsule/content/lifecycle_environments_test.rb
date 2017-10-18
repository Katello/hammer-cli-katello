require_relative '../../test_helper'
require_relative 'capsule_content_helpers'
require 'hammer_cli_katello/capsule'

module HammerCLIKatello
  module Capsule
    class Content
      describe Content::ListLifecycleEnvironmentsCommand do
        include CapsuleContentHelpers

        it 'allows minimal options' do
          expect_lifecycle_environments_list(params: {'id' => '1'}, returns: {})

          run_cmd(%w(capsule content lifecycle-environments --id 1))
        end
      end
    end
  end
end
