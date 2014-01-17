module HammerCLIKatello

  module Resource

    def resource_config
      config = {}
      config[:base_url] = HammerCLI::Settings.get(:katello, :host)
      config[:username] = HammerCLI::Settings.get(:katello, :username)
      config[:password] = HammerCLI::Settings.get(:katello, :password)
      config
    end

  end

end
