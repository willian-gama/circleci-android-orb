#!/bin/bash

if [ "$(git status fastlane/metadata/ --porcelain)" ]; then
  echo "Contains metadata updates"
  git config user.email "engineering+mobiledeploy@kitmanlabs.com"
  git config user.name "Mobile Deployer"
  git add fastlane/metadata/*
  git commit -m "[skip ci] Updated metadata"
  git push origin "$CIRCLE_BRANCH"
else
  echo "Skip metadata updates"
fi