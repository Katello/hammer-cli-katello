module HammerCLIKatello
  module LocalHelper
    def parse_subcommand
      return super if File.exist?('/usr/share/foreman')

      raise "This command can only be run on the same server that Foreman is running on " \
        "and cannot be run remotely."
    end
  end
end
