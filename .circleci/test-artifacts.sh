#!/usr/bin/env bash
##
# Copy artifacts from the app container to the build host for storage.
#
set -e

SCREENSHOT_DIR="$(docker exec $(docker-compose ps -q cli) sh -c "test -d /app/screenshots" && echo $?)"

if [[ $SCREENSHOT_DIR == 0 ]]; then
  docker cp $(docker-compose ps -q cli):/app/screenshots /tmp/artifacts/behat
fi
