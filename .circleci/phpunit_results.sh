#!/usr/bin/env bash
##
# Moves phpunit results from inside container to outside.
#
set -e
docker cp $(docker-compose ps -q cli):/app/phpunit/ /tmp/
