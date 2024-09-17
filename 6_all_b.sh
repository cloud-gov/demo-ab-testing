#!/usr/bin/env bash
set -euo pipefail

export DOMAIN=app.cloud.gov

fail() {
  echo $@
  exit 1
}

set -x
cf set-env $APP_NAME WEIGHTING "100% version_b; * version_a;"
cf restage --strategy rolling  $APP_NAME
set +x
