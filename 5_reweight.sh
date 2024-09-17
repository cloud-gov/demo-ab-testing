#!/usr/bin/env bash
set -euo pipefail

export DOMAIN=app.cloud.gov

fail() {
  echo $@
  exit 1
}

set -x
cf set-env $APP_NAME WEIGHTING "80% version_a; * version_b;"
cf restart $APP_NAME
set +x
