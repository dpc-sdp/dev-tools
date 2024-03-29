#!/usr/bin/env bash
##
# Install current module.
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
TEST_PACKAGE_NAME=${TEST_PACKAGE_NAME:-tide_test}
TEST_PACKAGE_VERSION=${TEST_PACKAGE_VERSION:-^4.0}
URI=${LOCALDEV_URL:-dev}

echo "==> COMPOSER_MEMORY_LIMIT=$COMPOSER_MEMORY_LIMIT"

# Extract module name from the *.info.yml file, if not provided.
if [ "$PACKAGE_NAME" == "" ]; then
  PACKAGE_NAME=$(find * -maxdepth 0 -name '*.info.yml'|cut -d. -f1)
fi
[ "$PACKAGE_NAME" == "" ] && "ERROR: Package name is not provided" && exit 1

if grep -q 'type: module' *.info.yml; then
  echo "==> Started $PACKAGE_NAME module installation"
else
  echo "Skipping module installation as current project is not a module"
  exit 0
fi

# Require an additional test package.
[ "${PACKAGE_NAME}" != "${TEST_PACKAGE_NAME}" ] && composer require --prefer-source ${PACKAGE_ORG}/${TEST_PACKAGE_NAME}:${TEST_PACKAGE_VERSION}

# Require module from local repository.
composer require --prefer-source ${PACKAGE_ORG}/${PACKAGE_NAME}:@dev

# If running with suggested modules, install them first.
if [ "$INSTALL_SUGGEST" == "1" ] ; then
  composer_suggests=$(cat ${COMPOSER} | gojq -r 'select(.suggest != null) | .suggest | keys[]')
  for composer_suggest in $composer_suggests
  do
    echo "==> Requiring suggested module $composer_suggest"
    composer require $composer_suggest
  done

  drupal_suggests=$(cat ${COMPOSER} | gojq -r 'select(.suggest != null) | .suggest | keys[]' | sed "s/$PACKAGE_ORG\///" | cut -f1 -d":")
  for drupal_suggest in $drupal_suggests
  do
    echo "==> Enabling suggested module $drupal_suggest"
    drush -r ${APP}/${WEBROOT} --uri=${URI} en -y $drupal_suggest
  done
fi

drush -r ${APP}/${WEBROOT} --uri=${URI} en -y ${PACKAGE_NAME}

echo "==> Finished $PACKAGE_NAME module installation"
