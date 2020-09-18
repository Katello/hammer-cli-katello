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

    class ResolveCommand < HammerCLIKatello::SingleResourceCommand
      include HammerCLIForemanTasks::Async
      resource :host_tracer, :resolve
      command_name "resolve"

      success_message _("Traces are being resolved with task %{id}.")
      failure_message _("Could not resolve traces")

      validate_options do
        option(:option_trace_ids).required
        option(:option_host_id).required
      end

      build_options
    end

    autoload_subcommands
  end
end
