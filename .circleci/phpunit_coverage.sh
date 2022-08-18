#!/usr/bin/env bash
##
# Generate coverage report
#
set -e
echo "==> Generate coverage report"
ahoy cli "phpdbg -qrr vendor/bin/phpunit ./dpc-sdp --coverage-html /app/phpunit/coverage-report"
