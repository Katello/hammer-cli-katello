require_relative '../test_helper'
require 'hammer_cli_katello/repository'

module HammerCLIKatello
  describe Repository::RemoveContentCommand do
    it 'allows minimal parameters' do
      api_expects(:repositories, :remove_content) { |p| p['id'] == '1' && p['ids'] == %w(1) }
      run_cmd(%w(repository remove-content --ids 1 --id 1))
    end

    it 'resolves repository id' do
      api_expects(:repositories, :index) { |p| p['name'] == 'repo1' }
        .returns(index_response([{'id' => '1'}]))
      api_expects(:repositories, :remove_content) { |p| p['id'] == '1' && p['ids'] == %w(1) }
      run_cmd(%w(repository remove-content --ids 1 --name repo1))
    end
  end
end
