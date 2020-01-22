require_relative '../test_helper'

module HammerCLIKatello
  describe 'Organization::DeleteCommand' do
    it 'it requires the organization ID and must be resolved from name' do
      api_expects(:organizations, :index).with_params(
        :search => "name = \"my_org\"", :per_page => 1000, :page => 1
      )
      run_cmd(%w(organization delete --name my_org))
    end

    it 'it requires the organization ID and must be resolved from name' do
      api_expects(:organizations, :index).with_params(
        :search => "label = \"my_org\"", :per_page => 1000, :page => 1
      )
      run_cmd(%w(organization delete --label my_org))
    end

    it 'it requires the organization ID and must be resolved from name' do
      api_expects(:organizations, :index).with_params(
        :search => "title = \"my_org\"", :per_page => 1000, :page => 1
      )
      run_cmd(%w(organization delete --title my_org))
    end
  end
end
