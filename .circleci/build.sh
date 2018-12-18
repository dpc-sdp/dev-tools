#!/usr/bin/env bash
##
# Build site in CI.
#
set -e

# Override install profile for CI.
DRUPAL_PROFILE=testing

echo "==> Validate composer configuration"
composer validate --ansi --strict --no-check-all --no-check-lock

# Remove lines related to local configuration. This is used to avoid multiple
# docker-compose.yml files.
sed -i -e "/###/d" docker-compose.yml

ahoy build
