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

cf check-route $DOMAIN --hostname $APP_NAME | 
  grep -q 'Route.*does not exist' || fail "APP_NAME $APP_NAME is already taken, try again"

#  reserve route for later use
cf create-route $DOMAIN --hostname $APP_NAME 

[ -r sample-app/manifest.yml ] || git clone https://github.com/cloudfoundry-tutorials/sample-app.git ./sample-app


A_APP_NAME="a-${APP_NAME}"
cf push "${A_APP_NAME}" --path ./sample-app -f app_manifest.yml \
  --var app_name="${A_APP_NAME}" --var test_var=TEST_A

B_APP_NAME="b-${APP_NAME}"
cf push "${B_APP_NAME}" --path ./sample-app -f app_manifest.yml \
  --var app_name="${B_APP_NAME}" --var test_var=TEST_B


echo "We can cheat A/B testing by mapping both hosts to the same route"
set -x
cf map-route ${A_APP_NAME} $DOMAIN --hostname ${APP_NAME}-x
cf map-route ${B_APP_NAME} $DOMAIN --hostname ${APP_NAME}-x
set +x

echo ========================================
echo "Visit https://${APP_NAME}-x.app.cloud.gov"
echo "Then run "2_demo.sh"
echo ========================================


exit 0
