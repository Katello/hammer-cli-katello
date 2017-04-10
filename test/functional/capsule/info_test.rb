require_relative '../test_helper'
require_relative 'capsule_helpers'
require 'hammer_cli_katello/capsule'

module HammerCLIKatello
  describe Capsule do
    describe InfoCommand do
      include CapsuleHelpers

      it 'allows minimal options' do
        expect_capsule_info('id' => '1')

        run_cmd(%w(capsule info --id 1))
      end

      it 'resolves capsule ID from name' do
        expect_generic_capsule_search(
          params: { search: "name = \"capsule1\"" }, returns: {'id' => 1})
        expect_capsule_info('id' => 1)

        run_cmd(%w(capsule info --name capsule1))
      end
    end
  end
end
