#!/usr/bin/env bash
##
# Link current package.
#
# This script must run from within container.
#
set -e

CUR_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

PACKAGE_NAME=${PACKAGE_NAME:-}
PACKAGE_ORG=${PACKAGE_ORG:-dpc-sdp}
LOCAL_REPOS=${LOCAL_REPOS:-$PACKAGE_ORG}

# Extract module name from the *.info.yml file, if not provided.
if [ "$PACKAGE_NAME" == "" ]; then
  PACKAGE_NAME=$(find * -maxdepth 0 -name '*.info.yml'|cut -d. -f1)
fi
[ "$PACKAGE_NAME" == "" ] && "ERROR: Package name is not provided" && exit 1

echo "==> Started $PACKAGE_NAME package linking"

rm -Rf ${LOCAL_REPOS}/${PACKAGE_NAME}
mkdir -p ${LOCAL_REPOS}/${PACKAGE_NAME}
# Copy code at latest commit into local repository directory, so that it can be
# symlinked as a local package by composer.
git --git-dir=${CUR_DIR}/../.git --work-tree=${CUR_DIR}/.. ls-tree HEAD --name-only | xargs -I '{}' cp -R '{}' ${LOCAL_REPOS}/${PACKAGE_NAME}/
cp -Rf ${CUR_DIR}/../.git ${LOCAL_REPOS}/${PACKAGE_NAME}

# Add local package repository to composer configuration. It will by symlinked
# by default, rather then copied.
composer config repositories.${PACKAGE_ORG}/${PACKAGE_NAME} path ${LOCAL_REPOS}/${PACKAGE_NAME}

echo "==> Finished $PACKAGE_NAME package linking"
