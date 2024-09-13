#!/bin/bash

# https://github.com/CircleCI-Public/slack-orb/wiki/Dynamic-Templates
UPLOAD_BUILD_DATE=$(TZ=Europe/Dublin date +"%d/%m/%Y at %I:%M %p")

{
  echo "export UPLOAD_BUILD_APP_NAME=$APP_NAME"
  echo "export UPLOAD_BUILD_DATE='$UPLOAD_BUILD_DATE'"
  # shellcheck disable=SC2016 # Don't expand variable intentionally.
  echo 'export UPLOAD_BUILD_TEMPLATE=$(cat slack/upload_build.json)'
} >> "$BASH_ENV"

cat "$BASH_ENV"