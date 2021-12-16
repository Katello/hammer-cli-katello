module HammerCLIKatello
  module ContentViewComponentBase
    class ComponentCommand < HammerCLIKatello::SingleResourceCommand
      include OrganizationOptions
      include CompositeContentViewNameResolvable

      def get_components(composite_content_view_id)
        component_options = {:composite_content_view_id => composite_content_view_id}
        components = ::HammerCLIForeman.foreman_resource(:content_view_components).call(:index,
                                                         component_options)
        components["results"] || []
      end

      def get_component_by_name_or_id(composite_content_view_id, options)
        get_components(composite_content_view_id).find do |cv|
          cv["content_view"]["name"] == options[:name] || cv["content_view"]["id"] == options[:id]
        end
      end
    end

    class ComponentUpdateCommand < ComponentCommand
      option "--component-content-view-id", "COMPONENT_CONTENT_VIEW_ID",
             _("Content View identifier of the component who's latest version is desired"),
             :attribute_name => :option_content_view_id

      option "--component-content-view", "COMPONENT_CONTENT_VIEW_NAME",
             _("Content View name of the component who's latest version is desired"),
             :attribute_name => :option_content_view_name

      option "--component-content-view-version-id", "COMPONENT_CONTENT_VIEW_VERSION_ID",
             _("Content View Version identifier of the component"),
             :attribute_name => :option_component_content_view_version_id

      option "--component-content-view-version", "COMPONENT_CONTENT_VIEW_VERSION_VERSION",
             _("Content View Version number of the component. " \
               "Either use this or --component-content-view-version-id option"),
             :attribute_name => :option_component_content_view_version_version

      option ["--latest"], :flag,
             _("Select the latest version of the components content view is desired")

      def fetch_cv
        cv = option_content_view_id
        if cv.nil? && option_content_view_name
          cv_search_options = org_options.merge(
            HammerCLI.option_accessor_name('name') => option_content_view_name)

          cv = resolver.content_view_id(cv_search_options)
        end
        cv
      end

      def fetch_cvv(cv)
        cvv = option_component_content_view_version_id
        if cvv.nil?
          if option_component_content_view_version_version && cv.nil?
            raise _("Please provide --component-content-view-id")
          end
          if option_component_content_view_version_version.nil?
            raise _("Please provide --component-content-view-version-id or" \
                   " --component-content-view-version or" \
                   " --latest for the latest version")
          end

          cvv_search_options = org_options.merge(
            HammerCLI.option_accessor_name("content_view_id") => cv,
            HammerCLI.option_accessor_name("version") =>
              option_component_content_view_version_version
          )

          cvv = resolver.content_view_version_id(cvv_search_options)
        end
        cvv
      end
    end
  end

  class ContentViewComponent < HammerCLIKatello::Command
    resource :content_view_components
    command_name 'component'
    desc 'View and manage components'

    class ListCommand < HammerCLIKatello::ListCommand
      include OrganizationOptions
      include CompositeContentViewNameResolvable
      output do
        field :content_view_id, _("Content View Id")
        field :content_view_name, _("Name")
        field :version, _("Version")
        field :id, _("Component Id")
        field :current_version, _("Current Version")
        field :version_id, _("Version Id")
      end

      def extend_data(mod)
        if mod['latest']
          mod['version'] = _("Latest")
          if mod['content_view_version']
            mod['current_version'] = mod['content_view_version']['version']
            mod['version_id'] = "#{mod['content_view_version']['id']} (#{_('Latest')})"
          else
            mod['current_version'] = _("No Published Version")
          end
        else
          mod['version'] = mod['content_view_version']['version']
          mod['version_id'] = mod['content_view_version']['id']
        end
        mod['content_view_name'] = mod["content_view"]["name"]
        mod['content_view_id'] = mod["content_view"]["id"]
        mod
      end

      build_options
    end

    class AddComponents < HammerCLIKatello::ContentViewComponentBase::ComponentUpdateCommand
      resource :content_view_components, :add_components
      command_name "add"

      def request_params
        super.tap do |opts|
          cv = fetch_cv
          component = {
            latest: (option_latest? || false)
          }
          component[:content_view_id] = cv if cv
          component[:content_view_version_id] = fetch_cvv(cv) unless component[:latest]
          opts['components'] = [component]
        end
      end

      success_message _("Component added to content view.")
      failure_message _("Could not add the component")

      build_options do |o|
        o.expand.except(:components, :content_view_versions, :content_views)
        o.without(:components, :content_view_versions, :content_views)
      end
    end

    class UpdateCommand < HammerCLIKatello::ContentViewComponentBase::ComponentUpdateCommand
      action :update
      command_name "update"

      success_message _("Content view component updated.")
      failure_message _("Could not update the content view component")

      def update_id(opts)
        return if opts["id"] || opts["content_view_id"].nil? ||
                  opts["composite_content_view_id"].nil?

        component = get_component_by_name_or_id(opts["composite_content_view_id"],
                                          :id => opts["content_view_id"])
        opts["id"] = component["id"] if component
      end

      def request_params
        super.tap do |opts|
          cv = fetch_cv
          opts["content_view_id"] = cv if cv
          update_id(opts)

          if option_latest?
            opts["latest"] = true
            opts.delete("content_view_version_id")
          else
            opts["latest"] = false
            opts["content_view_version_id"] = fetch_cvv(opts["content_view_id"])
          end
        end
      end

      build_options do |o|
        o.expand.except(:content_view_versions, :content_view_version_id)
        o.without(:content_view_versions, :content_view_version_id)
      end
    end

    class RemoveComponents < HammerCLIKatello::ContentViewComponentBase::ComponentCommand
      action :remove_components
      command_name "remove"

      option ["--component-content-views"], "COMPONENT_CONTENT_VIEW_NAMES",
         _("Array of component content view names to remove. Comma separated list of values"),
         :attribute_name => :option_component_content_view_names

      option ["--component-content-view-ids"], "COMPONENT_CONTENT_VIEW_IDs",
         _("Array of component content view identfiers to remove. Comma separated list of values"),
         :attribute_name => :option_component_content_view_ids

      success_message _("Components removed from content view.")
      failure_message _("Could not remove the components")

      def component_content_view_names
        return [] unless option_component_content_view_names
        option_component_content_view_names.split(",").map(&:strip)
      end

      def component_content_view_ids
        return [] unless option_component_content_view_ids
        option_component_content_view_ids.split(",").map(&:strip)
      end

      def request_params
        super.tap do |opts|
          if option_component_content_view_names || option_component_content_view_ids
            component_cv_names = component_content_view_names
            component_cv_ids = component_content_view_ids
            component_ids = opts["component_ids"] || []
            components = get_components(opts["composite_content_view_id"])
            components.each do |comp|
              if component_cv_names.include?(comp["content_view"]["name"]) ||
                 component_cv_ids.include?(comp["content_view"]["id"].to_s)
                component_ids << comp["id"]
              end
            end
            opts["component_ids"] = component_ids.uniq
          end
        end
      end

      build_options
    end

    autoload_subcommands
  end
end
