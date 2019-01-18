#!/bin/sh
##
# Import prod db.
#

# Clear cache if db found.
echo "==> Searching for Drupal installation"
[[ "$(drush core-status bootstrap --pipe)" != "" ]] && echo "==> Existing Drupal site found" && drush cr
echo "==> Removing existing database tables"
drush sql-drop -y
echo "==> Importing database"
drush sqlc < /tmp/.data/db.sql
drush sqlsan --sanitize-password=DpcFakePass --sanitize-email=user+%uid@localhost -y
# Ensure cache cleared
drush cr
