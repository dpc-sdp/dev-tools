#!/bin/sh
##
# Drupal deployment.
#

echo "==> Running database updates"
# Use this command to debug during the build process
# /app/scripts/xdebug.sh /app/vendor/bin/drush -r /app/docroot updb -y
drush updb -y
drush entup -y
echo "==> Importing Drupal configuration"
drush cim -y
drush cr -y
echo "==> Importing vicgovau default content"
drush php-eval "module_load_install('vicgovau_core'); vicgovau_core_default_content_modules();"
echo "==> Enabling vicgovau modules"
drush php-eval "module_load_install('vicgovau_core'); vicgovau_core_enable_modules();"
drush cr -y

if [ "$DRUPAL_REFRESH_SEARCHAPI" ]; then
  echo "==> Refreshing Search API"
  drush search-api-enable
  drush search-api-clear
  drush search-api-index 0 50
fi
