#!/usr/bin/env bash
##
# Mirror repo branch.
#
set -e

MIRROR_GIT_BRANCH=${MIRROR_GIT_BRANCH:-$1}
MIRROR_GIT_REMOTE=${MIRROR_GIT_REMOTE:-origin}
# Flag to push the branch.
MIRROR_GIT_PUSH=${MIRROR_GIT_PUSH:-}

[ "$MIRROR_GIT_BRANCH" == "" ] && echo "ERROR: Git branch is not provided" && exit 1

git checkout -b $MIRROR_GIT_BRANCH

if [ "$MIRROR_GIT_PUSH" == "1" ]; then
  git push $MIRROR_GIT_REMOTE $MIRROR_GIT_BRANCH --force
else
  echo "Would push to $MIRROR_GIT_BRANCH"
fi
