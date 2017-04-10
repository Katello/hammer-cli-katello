require_relative '../test_helper'
require_relative 'capsule_helpers'
require 'hammer_cli_katello/capsule'

module HammerCLIKatello
  describe Capsule do
    describe ListCommand do
      include CapsuleHelpers

      it 'allows minimal options' do
        expect_generic_capsule_search

        run_cmd(%w(capsule list))
      end

      it 'allows search' do
        expect_generic_capsule_search(
          params: { 'search' => 'search' }, returns: {})

        run_cmd(%w(capsule list --search search))
      end
    end
  end
end
