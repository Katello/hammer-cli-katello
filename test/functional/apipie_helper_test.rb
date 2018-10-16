require File.join(File.dirname(__FILE__), '../test_helper')

describe 'apipie helper' do
  before do
    class ApipieTestHelper
      include HammerCLIKatello::ApipieHelper
    end

    @apipie_helper = ApipieTestHelper.new
  end

  it "calls show method apipie resource" do
    api_expects(:repositories, :show).with_params('id' => '1').returns({})
    assert @apipie_helper.show(:repositories, 'id' => '1')
  end

  it "calls index method apipie resource" do
    api_expects(:repositories, :index).with_params('name' => 'foo').returns('results' => [])
    assert @apipie_helper.index(:repositories, 'name' => 'foo')
  end

  it "calls destroy method apipie resource" do
    api_expects(:repositories, :destroy).with_params('id' => '1').returns({})
    assert @apipie_helper.destroy(:repositories, 'id' => '1')
  end

  it "call method for apipie resources works" do
    api_expects(:repositories, :index).with_params('name' => 'foo').returns('results' => [])
    assert @apipie_helper.call(:index, :repositories, 'name' => 'foo')
  end
end
