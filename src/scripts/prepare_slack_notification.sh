#!/bin/bash

#  https://github.com/CircleCI-Public/slack-orb/wiki/Dynamic-Templates
SLACK_NOTIFICATION_JSON=$(cat ci/slack/build_uploaded.json)
echo "export SLACK_BUILD_UPLOADED_TEMPLATE=$SLACK_NOTIFICATION_JSON" >> "$BASH_ENV"