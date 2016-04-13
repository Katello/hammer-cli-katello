module HammerCLIKatello

  class ContentViewPurge < HammerCLIKatello::Command
    command_name "purge"
    desc "Delete old versions of a content view"

    option "--id", "ID", _("content view numeric identifier"), :required => true
    option "--count", "COUNT", _("count of versions to keep"), :default => 3, :format => HammerCLI::Options::Normalizers::Number.new

    def resource_content_views
      HammerCLIForeman.foreman_resource(:content_views)
    end

    def resource_content_view_versions
      HammerCLIForeman.foreman_resource(:content_view_versions)
    end

    def execute
      if option_count < 0
        print_message _("Invalid value for --count parameter: value must be greater than 0.")
        HammerCLI::EX_USAGE
      else
        view = resource_content_views.call(:show, :id => option_id)

        # Sort versions by the number (1.0, 2.0, ...)
        all_versions = view['versions'].sort! do |a, b|
          a["version"].to_f <=> b["version"].to_f
        end

        # Keep only versions which are not used
        old_versions = all_versions.select! do |v|
          v["environment_ids"].empty?
        end

        # Check if there is something to do
        if option_count >= old_versions.size
          print_message _("No version to delete.")
          HammerCLI::EX_OK
        else
          # Keep only versions to delete in the array
          oldest_version = old_versions.slice(0, old_versions.size - option_count)

          # Delete versions that we have to purge
          oldest_version.each do |v|
            HammerCLIForeman.record_to_common_format(
              resource_content_view_versions.call(:destroy, :id => v["id"])
            )
            print_message _("Version '%{version}' of content view '%{view}' deleted.") %
            {
              :version => v["version"],
              :view => view["name"]
            }
          end
          HammerCLI::EX_OK
        end
      end
    end
  end

end
