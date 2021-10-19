#!/bin/sh

##
# Install new Drupal site.
#

DRUPAL_PROFILE=${DRUPAL_PROFILE:-testing}
DRUPAL_ADMIN_NAME=${DRUPAL_ADMIN_NAME:-admin}
DRUPAL_ADMIN_PASSWORD=${DRUPAL_ADMIN_PASSWORD:-admin}
APP=${APP:-/app}
WEBROOT=${WEBROOT:-docroot}
URI= ${LOCALDEV_URL:-dev}

drush -r ${APP}/${WEBROOT} si ${DRUPAL_PROFILE} -y --uri=${URI} --account-name=${DRUPAL_ADMIN_NAME} --account-pass=${DRUPAL_ADMIN_PASSWORD} install_configure_form.enable_update_status_module=NULL install_configure_form.enable_update_status_emails=NULL --site-name="Single Digital Presence Content Management System"
drush -r ${APP}/${WEBROOT} ublk --uri=${URI} 1
drush -r ${APP}/${WEBROOT} cr --uri=${URI} -y
drush -r ${APP}/${WEBROOT} --uri=${URI} php-eval "\$prefix = getenv('DRUPAL_MODULE_PREFIX'); if (\$prefix) { \$loaded = module_load_install(\$prefix . '_core'); if (\$loaded) { \$func = \$prefix . '_core_enable_modules'; \$func(TRUE); } }"
