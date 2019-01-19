#!/usr/bin/env bash
##
# Install current profile.
#
# This script must run from within container.
#
set -e

PACKAGE_NAME=${PACKAGE_NAME:-}
PACKAGE_ORG=${PACKAGE_ORG:-dpc-sdp}
LOCAL_REPOS=${LOCAL_REPOS:-$PACKAGE_ORG}
INSTALL_SUGGEST=${INSTALL_SUGGEST:-}
COMPOSER=${COMPOSER:-composer.build.json}
APP=${APP:-/app}
WEBROOT=${WEBROOT:-docroot}

# Extract module name from the *.info.yml file, if not provided.
if [ "$PACKAGE_NAME" == "" ]; then
  PACKAGE_NAME=$(find * -maxdepth 0 -name '*.info.yml'|cut -d. -f1)
fi
[ "$PACKAGE_NAME" == "" ] && "ERROR: Package name is not provided" && exit 1

echo "==> Started $PACKAGE_NAME profile installation"

# Require module from local repository.
composer require --prefer-source ${PACKAGE_ORG}/${PACKAGE_NAME}:@dev

# If running with suggested modules, install suggested modules first.
if [ "$INSTALL_SUGGEST" == "1" ] ; then
  composer_suggests=$(cat ${COMPOSER} | jq -r 'select(.suggest != null) | .suggest | keys_unsorted[]')
  for composer_suggest in $composer_suggests
  do
    echo "==> Requiring suggested module $composer_suggest"
    composer require $composer_suggest
  done
fi

echo "==> Finished $PACKAGE_NAME profile installation"
