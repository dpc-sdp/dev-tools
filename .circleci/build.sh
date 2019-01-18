#!/usr/bin/env bash
##
# Build site in CI.
#
set -e

# Override install profile for CI.
# @todo: Review if we still need this override for CI.
# DRUPAL_PROFILE=testing

echo "==> Validate composer configuration"
composer validate --ansi --strict --no-check-all --no-check-lock

# Process Docker Compose configuration. This is used to avoid multiple
# docker-compose.yml files.
sed -i -e "/###/d" docker-compose.yml
sed -i -e "s/##//" docker-compose.yml

ahoy build
