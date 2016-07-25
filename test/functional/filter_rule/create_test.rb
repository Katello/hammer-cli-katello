require_relative '../test_helper'
require 'hammer_cli_katello/filter_rule'

module HammerCLIKatello
  describe FilterRule::CreateCommand do
    it 'allows minimal options' do
      api_expects(:content_view_filter_rules, :create) do |p|
        p['content_view_filter_id'] == 1 && p['name'] == %w(rpm1)
      end
      run_cmd(%w(content-view filter rule create --content-view-filter-id 1 --name rpm1))
    end

    it 'allows multiple package names' do
      api_expects(:content_view_filter_rules, :create) do |p|
        p['content_view_filter_id'] == 1 && p['name'] == %w(rpm1 rpm2)
      end
      run_cmd(%w(content-view filter rule create --content-view-filter-id 1 --names rpm1,rpm2))
    end
  end
end
