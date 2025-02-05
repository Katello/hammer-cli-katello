#/bin/bash
shopt -s expand_aliases
#set -e
#set -x

# Check if podman is installed
if ! $(rpm -q --quiet podman) ; then
	echo "Error: podman is not installed."
 	exit 1
fi

# Check if the HAMMER_DIR environment variable exists and is not empty
if [ -z "${HAMMER_DIR+x}" ]; then
  # If the environment variable does not exist, use the current working directory
  HAMMER_DIR=$(pwd)
fi

if [ ! -f "$HAMMER_DIR/hammer_cli_katello.gemspec" ]; then
  # Not a hammer cli katello repo. Have the user set it and exit
  echo "Error: HAMMER_DIR needs to point to a hammer-cli-katello repo"
  exit 1
fi

chmod 777 $HAMMER_DIR
find $HAMMER_DIR -type d -exec chmod 777 {} +
podman run --rm -it --network=host  -v $HAMMER_DIR:/opt/app-root/src/hammer-cli-katello:Z ghcr.io/katello/hammer-cli-katello-devel:latest
