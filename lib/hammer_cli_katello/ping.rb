require 'hammer_cli_foreman/ping'

module HammerCLIKatello
  class PingCommand < HammerCLIKatello::Command
    resource :ping, :index

    output do
      from "services" do
        label "candlepin" do
          from "candlepin" do
            field "status", _("Status")
            field "_response", _("Server Response")
          end
        end

        label "candlepin_events" do
          from "candlepin_events" do
            field "status", _("Status")
            field "message", _("message")
            field "_response", _("Server Response")
          end
        end

        label "candlepin_auth" do
          from "candlepin_auth" do
            field "status", _("Status")
            field "_response", _("Server Response")
          end
        end

        label "katello_events" do
          from "katello_events" do
            field "status", _("Status")
            field "message", _("message")
            field "_response", _("Server Response")
          end
        end

        label "pulp3", :hide_blank => true do
          from "pulp3" do
            field "status", _("Status"), Fields::Field, :hide_blank => true
            field "_response", _("Server Response"), Fields::Field, :hide_blank => true
          end
        end

        label "foreman_tasks" do
          from "foreman_tasks" do
            field "status", _("Status")
            field "_response", _("Server Response")
          end
        end
      end # from "services"
    end # output do

    def execute
      d = send_request
      print_data d
      service_statuses = d['services'].values.map { |v| v['status'] }
      if d['status'] == _("FAIL") || service_statuses.include?(_("FAIL"))
        1
      else
        HammerCLI::EX_OK
      end
    end

    def send_request
      super.tap do |data|
        data['services'] ||= {}
        data['services'].each do |_, service|
          service['_response'] =
            HammerCLIKatello::CommandExtensions::Ping.get_server_response(service)
        end
      end
    end

    def request_options
      { with_authentication: false }
    end
  end # class PingCommand

  HammerCLIForeman::PingCommand.subcommand 'katello',
                                            HammerCLIKatello::PingCommand.desc,
                                            HammerCLIKatello::PingCommand
  HammerCLIForeman::PingCommand::ForemanCommand.extend_with(
    HammerCLIKatello::CommandExtensions::Ping.new
  )
end # module HammerCLIKatello
