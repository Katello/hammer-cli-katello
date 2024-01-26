module HammerCLIKatello
  module CommandExtensions
    class KickstartRepository < HammerCLI::CommandExtensions
      option_family associate: 'kickstart_repository' do
        child '--kickstart-repository', 'REPOSITORY_NAME', _('Kickstart repository name'),
              attribute_name: :option_kickstart_repository
      end

      request_params do |params, cmd_obj|
        resource_name = cmd_obj.resource.singular_name
        if cmd_obj.option_kickstart_repository && !cmd_obj.option_kickstart_repository_id
          resource_hash = if resource_name == 'hostgroup'
                            params[resource_name]
                          else
                            params[resource_name]['content_facet_attributes']
                          end

          resource_hash ||= {}

          env_id = resource_hash['lifecycle_environment_id']
          cv_id = resource_hash['content_view_id']

          raise _('Please provide --lifecycle-environment-id') unless env_id

          raise _('Please provide --content-view-id') unless cv_id
          # rubocop:disable LineLength
          resource_hash['kickstart_repository_id'] = HammerCLIKatello::CommandExtensions::KickstartRepository.fetch_repo_id(
            cv_id, env_id, cmd_obj.option_kickstart_repository
          )
          # rubocop:enable LineLength
        end
      end

      def self.fetch_repo_id(cv_id, env_id, repo_name)
        repo_resource = HammerCLIForeman.foreman_resource(:repositories)
        index_options = {
          content_view_id: cv_id,
          environment_id: env_id,
          name: repo_name
        }
        repos = repo_resource.call(:index, index_options)['results']
        if repos.empty?
          raise _("No such repository with name %{name}, in lifecycle environment"\
                    " %{environment_id} and content view %{content_view_id}") % index_options
        end
        repos.first['id']
      end
    end
  end
end
