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

        label "candlepin_auth" do
          from "candlepin_auth" do
            field "status", _("Status")
            field "_response", _("Server Response")
          end
        end

        label "pulp" do
          from "pulp" do
            field "status", _("Status")
            field "_response", _("Server Response")
          end
        end

        label "pulp_auth" do
          from "pulp_auth" do
            field "status", _("Status")
            field "_response", _("Server Response")
          end
        end

        label "elasticsearch" do
          from "elasticsearch" do
            field "status", _("Status")
            field "_response", _("Server Response")
          end
        end

        label "katello_jobs" do
          from "katello_jobs" do
            field "status", _("Status")
            field "_response", _("Server Response")
          end
        end

      end # from "services"
    end # output do

    def execute
      d = send_request
      print_data d
      d['status'] != _("FAIL") ? HammerCLI::EX_OK : 1
    end

    def send_request
      super.tap do |data|
        data['services'].each do |name, service|
          service['_response'] = get_server_response(service)
        end
      end
    end

    private

    def get_server_response(service_hash)
      if service_hash['duration_ms']
        _("Duration: %sms") % service_hash['duration_ms']
      else
        _("Message: %s") % service_hash['message']
      end
    end

  end # class PingCommand

  HammerCLI::MainCommand.subcommand("ping", _("get the status of the server"),
                                    HammerCLIKatello::PingCommand)

end # module HammerCLIKatello
