module HammerCLIKatello
  module ApipieHelper
    def show(resource, options = {})
      call(:show, resource, options)
    end

    def index(resource, options = {})
      call(:index, resource, options)['results']
    end

    def call(action, resource, options)
      HammerCLIForeman.foreman_resource(resource).call(action, options)
    end
  end
end
