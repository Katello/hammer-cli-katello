module HammerCLIKatello
  class HostTraces < HammerCLIKatello::Command
    desc "List traces on your hosts"

    class ListCommand < HammerCLIKatello::ListCommand
      resource :host_tracer, :index
      command_name "list"

      output do
        field :id, _("Trace ID")
        field :application, _("Application")
        field :helper, _("Helper")
        field :app_type, _("Type")
      end
      build_options
    end
    autoload_subcommands
  end
end
