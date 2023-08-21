module HammerCLIKatello
  module UnsupportedKatelloAgentCommandHelper
    def execute
      print_message(failure_message)
      HammerCLI::EX_UNAVAILABLE
    end

    def self.host_collection_help_text
      "Specify the host collection with the --search-query " \
        "parameter, e.g. `--search-query \"host_collection = MyCollection\"` or " \
        "`--search-query \"host_collection_id=6\"`"
    end

    def self.included(base)
      alternate_command = "hammer job-invocation create --feature #{base.rex_feature}"
      message = "Use the remote execution equivalent `#{alternate_command}`."
      if base.name =~ /HostCollection/
        message = "#{message} #{host_collection_help_text}"
      end
      base.desc "Not supported. #{message}"
      base.failure_message "Not supported. #{message}"
      base.option ["-h", "--help"], :flag, "Unsupported Operation - #{message}"
    end
  end
end
