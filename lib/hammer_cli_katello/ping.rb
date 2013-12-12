require 'hammer_cli'
require 'katello_api'
require 'hammer_cli_foreman/commands'

module HammerCLIKatello

  class PingCommand < HammerCLI::Apipie::ReadCommand

    resource KatelloApi::Resources::Ping, :index


    output do
      from "services" do

        label "candlepin" do
          from "candlepin" do
            field "status", "Status"
            field "duration_ms", "Duration"
            field "message", "Message"
          end
        end

        label "candlepin_auth" do
          from "candlepin_auth" do
            field "status", "Status"
            field "duration_ms", "Duration"
            field "message", "Message"
          end
        end

        label "pulp" do
          from "pulp" do
            field "status", "Status"
            field "duration_ms", "Duration"
            field "message", "Message"
          end
        end

        label "pulp_auth" do
          from "pulp_auth" do
            field "status", "Status"
            field "duration_ms", "Duration"
            field "message", "Message"
          end
        end

        label "elasticsearch" do
          from "elasticsearch" do
            field "status", "Status"
            field "duration_ms", "Duration"
            field "message", "Message"
          end
        end

        label "katello_jobs" do
          from "katello_jobs" do
            field "status", "Status"
            field "duration_ms", "Duration"
            field "message", "Message"
          end
        end

      end # from "services"
    end # output do

  end # class PingCommand

  HammerCLI::MainCommand.subcommand("ping", "get the status of the server", HammerCLIKatello::PingCommand)

end # module HammerCLIKatello
