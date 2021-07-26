#!/usr/bin/env bash
##
# Build composer config file from current and dev composer files.
#
# @note: Composer merge plugin does not merge all sections, so we are using jq.
#
set -e

COMPOSER_BUILD=${COMPOSER_BUILD:-composer.build.json}
COMPOSER_DEV=${COMPOSER_DEV:-composer.dev.json}

echo "==> Create a build composer file"
# @note: gojq needs to exist on host as the merging of Composer config is running
# before containers are started.
cat <<< "$(gojq -s --indent 4 -M 'def merge(a;b):
  reduce b[] as $item (a;
    reduce ($item | keys[]) as $key (.;
      $item[$key] as $val | ($val | type) as $type | .[$key] = if ($type == "object") then
        merge({}; [if .[$key] == null then {} else .[$key] end, $val])
      elif ($type == "array") then
        (.[$key] + $val | unique)
      else
        $val
      end)
    );
  merge({}; .)' composer.json $COMPOSER_DEV )" > ${COMPOSER_BUILD}
