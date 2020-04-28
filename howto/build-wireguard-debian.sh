#!/usr/bin/env bash
# script to build latest wireguard module and wg(8) utility

# exit on error
set -e

# display last non-zero exit code in a failed pipeline
set -o pipefail

# subshells and functions inherit ERR traps
set -E

# install dependencies if needed
sudo apt-get install -y libmnl-dev libelf-dev linux-headers-$(uname -r) build-essential pkg-config

# create build directory
BUILDDIR="$(mktemp -d)"

# remove the build directory on exit
function cleanup {
        rm -rf "$BUILDDIR"
}
trap cleanup EXIT

# specify directory for wireguard module
MODULEDIR="$BUILDDIR"/wireguard-linux-compat

# specify directory for wg(8)
TOOLDIR="$BUILDDIR"/wireguard-tools

# clone the kernel module source
git clone https://git.zx2c4.com/wireguard-linux-compat "$MODULEDIR"

# clone the wg(8) utility source
git clone https://git.zx2c4.com/wireguard-tools "$TOOLDIR"

# compile and install the module
make -C "$MODULEDIR"/src -j$(nproc)
sudo make -C "$MODULEDIR"/src install

# compile and install wg(8)
make -C "$TOOLDIR"/src -j$(nproc)
sudo make -C "$TOOLDIR"/src install

# display wireguard version
sudo wg --version
