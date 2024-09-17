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

cf add-network-policy $APP_NAME a-${APP_NAME} --protocol tcp --port 8080
cf add-network-policy $APP_NAME b-${APP_NAME} --protocol tcp --port 8080
