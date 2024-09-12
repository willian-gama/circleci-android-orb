#!/bin/bash

mkdir -p ~/test-results/screenshots

SCREENSHOT_FAILURES=build/paparazzi/failures

for module in */; do
  failure_folder="$module/$SCREENSHOT_FAILURES"
  save_in_folder=~/test-results/screenshots/$module

  if [ -d "$failure_folder" ] && [ "$(ls -A "$failure_folder" )" ]; then
    mkdir -p "$save_in_folder"
    find . -type f -regex ".*/$SCREENSHOT_FAILURES/delta-.*png" -exec cp {} "$save_in_folder" \;
  fi
done