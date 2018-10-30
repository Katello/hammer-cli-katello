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
