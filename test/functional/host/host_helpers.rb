module HostHelpers
  def expect_host_search(name, id)
    ex = api_expects(:hosts, :index, 'Find the host') do |par|
      par[:search] == "name = \"#{name}\""
    end
    ex.returns(index_response([{'id' => id}]))
  end
end
