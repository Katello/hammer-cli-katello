module HammerCLIKatello
  module ForemanSearchOptionsCreators
    def create_organizations_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:organizations))
    end

    def create_smart_proxies_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:smart_proxies))
    end

    def create_capsules_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:smart_proxies))
    end

    def create_hosts_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:hosts))
    end

    def create_architectures_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:architectures))
    end

    def create_operatingsystems_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:operatingsystems))
    end

    def create_domains_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:domains))
    end

    def create_locations_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:locations))
    end

    def create_media_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:media))
    end

    def create_hostgroups_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:hostgroups))
    end

    def create_ptables_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:ptables))
    end

    def create_puppet_ca_proxies_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:puppet_ca_proxies))
    end

    def create_puppet_proxies_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:puppet_proxies))
    end

    def create_puppetclasses_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:puppetclasses))
    end

    def create_subnets_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:subnets))
    end

    def create_realms_search_options(options)
      create_search_options_without_katello_api(options, api.resource(:realms))
    end
  end
end
