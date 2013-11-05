require 'hammer_cli'
require 'katello_api'
require 'hammer_cli_katello/resource'

module KatelloCLIPing

  class IndexCommand < HammerCLI::AbstractCommand
    include HammerCLIKatello::Resource

    def initialize(*args)
      super(args)
      @ping = KatelloApi::Resources::Ping.new(resource_config)
    end

    def execute
      #TODO there's gotta be a better way to do this output
      dsl = HammerCLI::Output::Dsl.new
      dsl.build do

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

        end
      end

      definition = HammerCLI::Output::Definition.new
      definition.append(dsl.fields)
      print_records(definition, @ping.index[0])
      HammerCLI::EX_OK
    end

  end

  HammerCLI::MainCommand.subcommand("ping", "ping the katello server", KatelloCLIPing::IndexCommand)
end
