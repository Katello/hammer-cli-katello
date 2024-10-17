module HammerCLIKatello
  module ForemanSearchOptionsCreators
    def create_environments_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:environments), mode)
    end

    def create_organizations_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:organizations), mode)
    end

    def create_smart_proxies_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:smart_proxies), mode)
    end

    def create_capsules_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:smart_proxies), mode)
    end

    def create_hosts_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:hosts), mode)
    end

    def create_architectures_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:architectures), mode)
    end

    def create_operatingsystems_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:operatingsystems), mode)
    end

    def create_debs_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:debs), mode)
    end

    def create_domains_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:domains), mode)
    end

    def create_locations_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:locations), mode)
    end

    def create_media_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:media), mode)
    end

    def create_hostgroups_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:hostgroups), mode)
    end

    def create_ptables_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:ptables), mode)
    end

    def create_subnets_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:subnets), mode)
    end

    def create_realms_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:realms), mode)
    end

    def create_packages_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:packages), mode)
    end

    def create_compute_resources_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:compute_resources), mode)
    end

    def create_compute_profiles_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:compute_profiles), mode)
    end

    def create_images_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:images), mode)
    end

    def create_users_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:users), mode)
    end

    def create_usergroups_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:usergroups), mode)
    end

    def create_http_proxies_search_options(options, mode = nil)
      create_search_options_without_katello_api(options, api.resource(:http_proxies), mode)
    end
  end
end
