#!/usr/bin/env bash
set -euo pipefail

export DOMAIN=app.cloud.gov

fail() {
  echo $@
  exit 1
}

if [ -z "${APP_NAME}" ]; then
  fail "Must set base APP_NAME environment variable"
fi

cf push $APP_NAME -f proxy/manifest.yml --path proxy --var proxy-app-name="${APP_NAME}" 

echo "Now visit https://$APP_NAME.$DOMAIN"

exit 0
