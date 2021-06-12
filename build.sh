#!/usr/bin/env bash
# build, tag, and push docker images

# exit if a command fails
set -o errexit

# exit if required variables aren't set
set -o nounset

# if podman is installed, default to using it
if command -v podman 2>&1 >/dev/null; then
	echo "using podman..."
	# enable aliases for non-interactive mode
	shopt -s expand_aliases	
	alias docker="podman"

# if apt is installed, use the debian dependencies
elif command -v docker 2>&1 >/dev/null; then
	echo "using docker..."

# otherwise exit
else
	echo "could not find docker or podman, exiting"
	exit 1
fi

# if no registry is provided, tag image as "local" registry
registry="${REGISTRY:-local}"
echo "using registry $registry..."

# get git revision
git_ver="$(git rev-parse --short HEAD)"
echo "on git revision $git_ver..."

# create docker images
docker build -t "$registry/galenguyer.com:latest" \
             -t "$registry/galenguyer.com:$git_ver" \
             -f Dockerfile .

 # if a registry is specified, push to it
if [ "$registry" != "local" ]; then
  docker push "$registry/galenguyer.com:latest"
  docker push "$registry/galenguyer.com:$git_ver"
fi
