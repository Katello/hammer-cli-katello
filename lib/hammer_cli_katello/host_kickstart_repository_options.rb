module HammerCLIKatello
  module HostKickstartRepositoryOptions
    def self.included(base)
      base.option "--kickstart-repository", "REPOSITORY_NAME",
             _("Kickstart repository name "),
             :attribute_name => :option_kickstart_repository
    end

    def request_params
      super.tap do |mod|
        resource_name = resource.singular_name
        if option_kickstart_repository && !option_kickstart_repository_id
          resource_hash = if resource_name == "hostgroup"
                            mod[resource_name]
                          else
                            mod[resource_name]["content_facet_attributes"]
                          end

          resource_hash ||= {}

          env_id = resource_hash["lifecycle_environment_id"]
          cv_id = resource_hash["content_view_id"]

          raise _("Please provide --lifecycle-environment-id") unless env_id

          raise _("Please provide --content-view-id") unless cv_id

          resource_hash["kickstart_repository_id"] = fetch_repo_id(cv_id, env_id,
                                                                   option_kickstart_repository)
        end
      end
    end

    def fetch_repo_id(cv_id, env_id, repo_name)
      repo_resource = HammerCLIForeman.foreman_resource(:repositories)
      index_options = {
        "content_view_id" => cv_id,
        "environment_id" => env_id,
        "name" => repo_name
      }
      repos = repo_resource.call(:index, index_options)["results"]
      if repos.empty?
        raise _("No such repository with name %{name}, in lifecycle environment"\
                  " %{environment_id} and content view %{content_view_id}" % index_options)
      end
      repos.first["id"]
    end
  end
end
