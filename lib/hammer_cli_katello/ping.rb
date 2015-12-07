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

        label "pulp_auth", :hide_blank => true do
          from "pulp_auth" do
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
      d['status'] != _("FAIL") ? HammerCLI::EX_OK : 1
    end

    def send_request
      super.tap do |data|
        data['services'].each do |_, service|
          service['_response'] = get_server_response(service)
        end
      end
    end

    private

    def get_server_response(service_hash)
      if service_hash['duration_ms']
        _("Duration: %sms") % service_hash['duration_ms']
      elsif service_hash['message']
        _("Message: %s") % service_hash['message']
      end
    end

  end # class PingCommand

end # module HammerCLIKatello
