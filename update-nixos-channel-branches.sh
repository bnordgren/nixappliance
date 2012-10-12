#!/bin/sh
#
# Update channel-nixos branch for nixos and nixpkgs repos

# config
NIXOS_REPO=$HOME/nixappliance/nixos
NIXPKGS_REPO=$HOME/nixappliance/nixpkgs
CHANNEL=/nix/var/nix/profiles/per-user/root/channels/nixos
REV_FILE=$CHANNEL/nixos/svn-revision
BRANCH="channel-nixos"
UPDATE_CMD="git update-ref refs/heads/$BRANCH"
PUSH_CMD="git push origin $BRANCH:$BRANCH"

set -x
sudo -H nix-channel --update
set +x

# get nixos and nixpkgs revision from channel
REV_INFO=$(cut -d'_' -f2 < $REV_FILE)
NIXOS_REV=$(echo $REV_INFO | cut -d'-' -f1)
NIXPKGS_REV=$(echo $REV_INFO | cut -d'-' -f2)

echo "Using revision file:"
echo "  $REV_FILE"
echo "nixos revision:   $NIXOS_REV"
echo "nixpkgs revision: $NIXPKGS_REV"
echo

# update branches
set -x
(cd $NIXOS_REPO && git fetch --all && $UPDATE_CMD $NIXOS_REV && $PUSH_CMD)
(cd $NIXPKGS_REPO && git fetch --all && $UPDATE_CMD $NIXPKGS_REV && $PUSH_CMD)
