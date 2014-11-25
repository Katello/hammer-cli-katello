require 'hammer_cli_katello/docker_image'
require 'hammer_cli_katello/docker_tag'

module HammerCLIKatello
  class DockerCommand < HammerCLIKatello::Command
    subcommand 'image',
               HammerCLIKatello::DockerImageCommand.desc,
               HammerCLIKatello::DockerImageCommand
    subcommand 'tag',
               HammerCLIKatello::DockerTagCommand.desc,
               HammerCLIKatello::DockerTagCommand
  end
end
