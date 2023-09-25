require_relative '../../test_helper'
require_relative 'capsule_content_helpers'
require 'hammer_cli_katello/capsule'

module HammerCLIKatello
  module Capsule
    class Content
      describe Content::ReclaimSpaceCommand do
        include CapsuleContentHelpers

        it 'allows minimal options' do
          api_expects(:capsule_content, :reclaim_space, 'Reclaim space').with_params('id' => 1)
          run_cmd(%w(capsule content reclaim-space --id 1))
        end

        it 'fails on missing ID' do
          api_expects_no_call
          assert_failure run_cmd(%w(capsule content reclaim-space)), "Missing arguments for '--id'."
        end
      end
    end
  end
end
