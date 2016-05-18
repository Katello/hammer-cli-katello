module CapsuleContentHelpers
  def expect_capsule_search(name, id)
    ex = api_expects(:smart_proxies, :index, 'Find the proxy') do |par|
      par[:search] == "name = \"#{name}\""
    end
    ex.returns(index_response([{'id' => id}]))
  end
end
