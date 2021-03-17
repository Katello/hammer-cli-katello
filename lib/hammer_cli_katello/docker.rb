module HammerCLIKatello
  class DockerCommand < HammerCLI::AbstractCommand
    require 'hammer_cli_katello/docker_manifest'
    subcommand 'manifest',
               HammerCLIKatello::DockerManifestCommand.desc,
               HammerCLIKatello::DockerManifestCommand

    require 'hammer_cli_katello/docker_tag'
    subcommand 'tag',
               HammerCLIKatello::DockerTagCommand.desc,
               HammerCLIKatello::DockerTagCommand
  end
end
