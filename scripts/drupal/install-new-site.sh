#!/bin/sh

##
# Install new Drupal site.
#

DRUPAL_PROFILE=${DRUPAL_PROFILE:-testing}
DRUPAL_ADMIN_NAME=${DRUPAL_ADMIN_NAME:-admin}
DRUPAL_ADMIN_PASSWORD=${DRUPAL_ADMIN_PASSWORD:-admin}
APP=${APP:-/app}
WEBROOT=${WEBROOT:-docroot}

drush -r ${APP}/${WEBROOT} si ${DRUPAL_PROFILE} -y --account-name=${DRUPAL_ADMIN_NAME} --account-pass=${DRUPAL_ADMIN_PASSWORD} install_configure_form.enable_update_status_module=NULL install_configure_form.enable_update_status_emails=NULL --site-name="Single Digital Presence Content Management System"
drush -r ${APP}/${WEBROOT} ublk 1
drush -r ${APP}/${WEBROOT} cr -y
drush -r ${APP}/${WEBROOT} php-eval "\$prefix = getenv('DRUPAL_MODULE_PREFIX'); if (\$prefix) { \$loaded = module_load_install(\$prefix . '_core'); if (\$loaded) { \$func = \$prefix . '_core_enable_modules'; \$func(TRUE); } }"
