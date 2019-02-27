# rubocop:disable Metrics/ModuleLength
module HammerCLIKatello
  module CVImportExportHelper
    PUBLISHED_REPOS_DIR = "/var/lib/pulp/published/yum/https/repos/".freeze

    def fetch_cvv_repositories(cvv)
      cvv['repositories'].collect do |repo|
        show(:repositories, 'id' => repo['id'], :full_result => true)
      end
    end

    def find_local_component_id(component_from_export)
      *name, version = component_from_export.split(' ')
      name = name.join(' ')
      existing_component_cv = content_view(name, options['option_organization_id'])
      found_composite_version = existing_component_cv['versions'].select do |v|
        v['version'] == version
      end
      if found_composite_version.empty?
        raise _("Unable to find CV version %{cvv} on system. Please ensure it " \
                "is already imported." % {'cvv' => component_from_export})
      end
      found_composite_version.first['id']
    end

    def puppet_check(cvv)
      unless cvv['puppet_modules'].empty?
        raise _("The Content View '#{cvv['content_view']['label']}'"\
        " contains Puppet modules, this is not supported at this time."\
        " Please remove the modules, publish a new version"\
        " and try the export again.")
      end
    end

    def check_repo_type(repositories)
      repositories.select do |repo|
        if repo['content_type'] != 'yum'
          raise _("The Repository '#{repo['name']}' is a non-yum repository."\
          " Only Yum is supported at this time."\
          " Please remove the repository from the Content View,"\
          " republish and try the export again.")
        end
      end
    end

    def check_repo_download_policy(repositories)
      non_immediate = repositories.select do |repo|
        show(:repositories, 'id' => repo['library_instance_id'])['download_policy'] != 'immediate'
      end
      unless non_immediate.empty?
        non_immediate_names = repositories.collect { |repo| repo['name'] }
        msg = <<~MSG
          All exported repositories must be set to an immediate download policy and re-synced.
          The following repositories need action:
            #{non_immediate_names.join(', ')}
        MSG
        raise _(msg)
      end
    end

    def import_checks(cv, import_cv, major, minor)
      version = "#{major}.#{minor}".to_f

      if import_cv.nil?
        raise _("The Content View #{cv['name']} is not present on this server,"\
        " please create the Content View and try the import again.")
      end

      if import_cv['latest_version'].to_f >= version
        raise _("The latest version (#{import_cv['latest_version']}) of"\
        " the Content View '#{cv['name']}'"\
        " is greater or equal to the version you are trying to import (#{version})")
      end

      unless import_cv['repository_ids'].nil?
        repositories = import_cv['repository_ids'].collect do |repo_id|
          show(:repositories, 'id' => repo_id)
        end
        repositories.each do |repo|
          if repo['mirror_on_sync'] == true
            raise _("The Repository '#{repo['name']}' is set with Mirror-on-Sync to YES."\
            " Please change Mirror-on-Sync to NO and try the import again.")
          end
        end
      end
    end

    def untar_export(options)
      export_tar_file = options[:filename]
      export_tar_dir =  options[:dirname]
      export_tar_prefix = options[:prefix]

      Dir.chdir(export_tar_dir) do
        `tar -xf #{export_tar_file}`
      end

      Dir.chdir("#{export_tar_dir}/#{export_tar_prefix}") do
        if File.exist?(export_tar_file.gsub('.tar', '-repos.tar'))
          `tar -xf #{export_tar_file.gsub('.tar', '-repos.tar')}`
        end
      end
    end

    def obtain_export_params(option_export_tar)
      export_tar_file = File.basename(option_export_tar)
      {:filename => export_tar_file,
       :dirname => File.dirname(option_export_tar),
       :prefix => export_tar_file.gsub('.tar', '')}
    end

    def read_json(options)
      export_tar_file = options[:filename]
      export_tar_dir =  options[:dirname]
      export_tar_prefix = options[:prefix]

      json_file = export_tar_file.gsub('tar', 'json')
      json_file = "#{export_tar_dir}/#{export_tar_prefix}/#{json_file}"
      json_file = File.read(json_file)
      JSON.parse(json_file)
    end

    def export_json(export_json_options)
      content_view_version = export_json_options[:cvv]
      repositories = export_json_options[:repositories]
      json = {
        "name" => content_view_version['content_view']['name'],
        "major" => content_view_version['major'],
        "minor" => content_view_version['minor']
      }
      json["composite_components"] = export_json_options[:component_cvvs]
      json["repositories"] = repositories.collect do |repo|
        {
          "id" => repo['id'],
          "label" => repo['label'],
          "content_type" => repo['content_type'],
          "backend_identifier" => repo['backend_identifier'],
          "relative_path" => repo['relative_path'],
          "on_disk_path" => "#{PUBLISHED_REPOS_DIR}/#{repo['relative_path']}",
          "rpm_filenames" => repo['packages'].collect { |package| package['filename'] },
          "errata_ids" => repo['errata'].collect { |errata| errata['errata_id'] }
        }
      end
      json
    end
  end
end
