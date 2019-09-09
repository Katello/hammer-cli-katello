require 'hammer_cli_foreman/status'

module HammerCLIKatello
  class StatusCommand < HammerCLIKatello::Command
    resource :ping, :server_status

    output do
      field :version, _('Version')
      field :timeUTC, _('Time UTC'), Fields::Date
    end

    def request_options
      { with_authentication: false }
    end
  end

  HammerCLIForeman::StatusCommand.subcommand 'katello',
                                             HammerCLIKatello::StatusCommand.desc,
                                             HammerCLIKatello::StatusCommand
  HammerCLIForeman::StatusCommand::ForemanCommand.extend_with(
    HammerCLIKatello::CommandExtensions::Ping.new
  )
end
