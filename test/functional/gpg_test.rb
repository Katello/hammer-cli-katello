require_relative 'test_helper'
require 'hammer_cli_katello/gpg_key'

module HammerCLIKatello
  describe GpgKeyCommand::ListCommand do
    it 'warns of deprecation' do
      result = run_cmd(%w(gpg list))
      assert_match(/deprecated/, result.err)
    end
  end

  describe GpgKeyCommand::InfoCommand do
    it 'warns of deprecation' do
      result = run_cmd(%w(gpg info))
      assert_match(/deprecated/, result.err)
    end
  end

  describe GpgKeyCommand::CreateCommand do
    it 'warns of deprecation' do
      result = run_cmd(%w(gpg create))
      assert_match(/deprecated/, result.err)
    end
  end

  describe GpgKeyCommand::UpdateCommand do
    it 'warns of deprecation' do
      result = run_cmd(%w(gpg update))
      assert_match(/deprecated/, result.err)
    end
  end

  describe GpgKeyCommand::DeleteCommand do
    it 'warns of deprecation' do
      result = run_cmd(%w(gpg delete))
      assert_match(/deprecated/, result.err)
    end
  end
end
