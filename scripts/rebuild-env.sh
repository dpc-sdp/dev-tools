#!/bin/sh
##
# Rebuild environment.
#

# Fetch prod db.
./scripts/drush-download-db.sh

# Import db.
./scripts/drupal/import-db.sh

# Deploy drupal.
./scripts/drupal/deploy.sh
