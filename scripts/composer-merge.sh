#!/usr/bin/env bash
##
# Build composer config file from current and dev composer files.
#
# @note: Composer merge plugin does not merge all sections, so we are using jq.
#
set -e

COMPOSER_BUILD=${COMPOSER_BUILD:-composer.build.json}
COMPOSER_DEV=${COMPOSER_DEV:-composer.dev.json}

echo "==> Create a build composer file"
# @note: jq needs to exist on host as the merging of Composer config is running
# before containers are started.
cat <<< "$(jq --indent 4 -M -s '.[0] * .[1]' composer.json $COMPOSER_DEV )" > ${COMPOSER_BUILD}
