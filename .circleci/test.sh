#!/usr/bin/env bash
##
# Run tests in CI.
#
set -e

echo "==> Lint code"
ahoy lint

echo "==> Run Behat tests"
mkdir -p /tmp/artifacts/behat
ahoy test-behat || ahoy test-behat -- --rerun
