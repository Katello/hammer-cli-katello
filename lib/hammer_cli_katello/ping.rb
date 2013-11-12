require 'hammer_cli'
require 'katello_api'
require 'hammer_cli_katello/resource'

module KatelloCLIPing

  class IndexCommand < HammerCLI::Apipie::ReadCommand
    include HammerCLIKatello::Resource

    command_name "ping"
    resource KatelloApi::Resources::Ping, :index
    output do
      from "status" do

        label "candlepin" do
          from "candlepin" do
            field "result", "Result"
            field "duration_ms", "Duration"
          end
        end

        label "candlepin_auth" do
          from "candlepin_auth" do
            field "result", "Result"
            field "duration_ms", "Duration"
          end
        end

        label "pulp" do
          from "pulp" do
            field "result", "Result"
            field "duration_ms", "Duration"
          end
        end

        label "pulp_auth" do
          from "pulp_auth" do
            field "result", "Result"
            field "duration_ms", "Duration"
          end
        end

        label "elasticsearch" do
          from "elasticsearch" do
            field "result", "Result"
            field "duration_ms", "Duration"
          end
        end

        label "katello_jobs" do
          from "katello_jobs" do
            field "result", "Result"
            field "duration_ms", "Duration"
          end
        end

      end # from "status"
    end # output do

  end # class IndexCommand

  HammerCLI::MainCommand.subcommand("ping", "ping the katello server", KatelloCLIPing::IndexCommand)

end # module KatelloCLIPing
