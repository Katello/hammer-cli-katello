module HammerCLIKatello

  class PingCommand < HammerCLI::Apipie::ReadCommand

    resource KatelloApi::Resources::Ping, :index

    output do
      from "services" do

        label "candlepin" do
          from "candlepin" do
            field "status", "Status"
            field "_response", "Server Response"
          end
        end

        label "candlepin_auth" do
          from "candlepin_auth" do
            field "status", "Status"
            field "_response", "Server Response"
          end
        end

        label "pulp" do
          from "pulp" do
            field "status", "Status"
            field "_response", "Server Response"
          end
        end

        label "pulp_auth" do
          from "pulp_auth" do
            field "status", "Status"
            field "_response", "Server Response"
          end
        end

        label "elasticsearch" do
          from "elasticsearch" do
            field "status", "Status"
            field "_response", "Server Response"
          end
        end

        label "katello_jobs" do
          from "katello_jobs" do
            field "status", "Status"
            field "_response", "Server Response"
          end
        end

      end # from "services"
    end # output do

    def execute
      d = retrieve_data
      if HammerCLI::Settings.get(:log_api_calls)
        logger.debug "Retrieved data: " + d.ai(:raw => true)
      end
      print_data d
      d['status'] != "FAIL" ? HammerCLI::EX_OK : 1
    end

    def retrieve_data
      super.tap do |data|
        data['services'].each do |name, service|
          service['_response'] = get_server_response(service)
        end
      end
    end

    private

    def get_server_response(service_hash)
      if service_hash['duration_ms']
        "Duration: #{service_hash['duration_ms']}ms"
      else
        "Message: #{service_hash['message']}"
      end
    end

  end # class PingCommand

  HammerCLI::MainCommand.subcommand("ping", "get the status of the server",
                                    HammerCLIKatello::PingCommand)

end # module HammerCLIKatello
