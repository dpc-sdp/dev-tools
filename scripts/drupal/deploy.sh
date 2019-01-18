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
echo "==> Importing site-specific default content"
drush php-eval "\$prefix = getenv('DRUPAL_MODULE_PREFIX'); module_load_install(\$prefix . '_core'); \$func = \$prefix . '_core_default_content_modules'; \$func();"
echo "==> Enabling site-specific modules"
drush php-eval "\$prefix = getenv('DRUPAL_MODULE_PREFIX'); module_load_install(\$prefix . '_core'); \$func = \$prefix . '_core_enable_modules'; \$func();"
drush cr -y

if [ "$DRUPAL_REFRESH_SEARCHAPI" ]; then
  echo "==> Refreshing Search API"
  drush search-api-enable
  drush search-api-clear
  drush search-api-index 0 50
fi
