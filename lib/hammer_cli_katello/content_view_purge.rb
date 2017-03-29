module HammerCLIKatello
  class ContentViewPurgeCommand < HammerCLIKatello::Command
    include HammerCLIForemanTasks::Async
    include OrganizationOptions

    command_name "purge"
    desc "Delete old versions of a content view"

    option "--id", "ID", _("Content View numeric identifier")
    option "--name", "NAME", _("Content View name")
    option "--count", "COUNT", _("count of unused versions to keep"),
           default: 3, format: HammerCLI::Options::Normalizers::Number.new

    validate_options do
      organization_options = [:option_organization_id, :option_organization_name, \
                              :option_organization_label]

      any(:option_name, :option_id).required

      if option(:option_name).exist?
        any(*organization_options).required
      end
    end

    build_options

    def resource_content_views
      HammerCLIForeman.foreman_resource(:content_views)
    end

    def resource_content_view_versions
      HammerCLIForeman.foreman_resource(:content_view_versions)
    end

    def all_options
      if super['option_id'].nil? && super['option_name']
        super['option_id'] = resolver.content_view_id(super)
      end
      super
    end

    def execute
      if option_count < 0
        output.print_error _("Invalid value for --count option: value must be 0 or greater.")
        return HammerCLI::EX_USAGE
      end

      # Check if there is something to do
      if option_count >= old_unused_versions.size
        output.print_error _("No versions to delete.")
        HammerCLI::EX_NOT_FOUND
      else
        versions_to_purge = old_unused_versions.slice(0, old_unused_versions.size - option_count)

        versions_to_purge.each do |v|
          purge_version(v)
        end
        HammerCLI::EX_OK
      end
    end

    private def purge_version(v)
      if option_async?
        task = resource_content_view_versions.call(:destroy, 'id' => v["id"])
        print_message _("Version '%{version}' of content view '%{view}' scheduled "\
                        "for deletion in task '%{task_id}'.") %
                      {version: v["version"], view: content_view["name"], task_id: task['id']}
      else
        task_progress(resource_content_view_versions.call(:destroy, 'id' => v["id"]))
        print_message _("Version '%{version}' of content view '%{view}' deleted.") %
                      {version: v["version"], view: content_view["name"]}
      end
    end

    private def content_view
      @content_view ||= resource_content_views.call(:show, 'id' => options['option_id'])
    end

    private def old_unused_versions
      return @old_unused_versions if @old_unused_versions

      all_versions = content_view['versions'].sort_by do |version|
        [version[:major], version[:minor]]
      end

      # Keep only versions which are not used
      @old_unused_versions = all_versions.select do |v|
        v["environment_ids"].empty?
      end
    end
  end
end
