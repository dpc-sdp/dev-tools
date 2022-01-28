#!/usr/bin/env bash
##
# Run phpunit tests in CI.
#
set -e

ahoy cli "mkdir -p /app/phpunit"
echo "==> Run phpunit tests"
ahoy cli "vendor/bin/phpunit ./dpc-sdp --log-junit /app/phpunit/junit.xml"
