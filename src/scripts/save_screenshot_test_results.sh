#!/bin/sh

# CURRENTLY NOT USED

mkdir -p ~/test-results/screenshots

for directory in */; do
  success_folder=$directory/build/reports/paparazzi
  failure_folder=$directory/out/failures
  save_in_folder=~/test-results/screenshots/${directory}

  # save successful reports
  if [ -d $success_folder ] && [ "$(ls -A $success_folder)" ]; then
    mkdir -p "${save_in_folder}/reports"
    cp -r "$success_folder/" "${save_in_folder}/reports"
  fi

  # save failure reports
  if [ -d $failure_folder ] && [ "$(ls -A $failure_folder )" ]; then
    mkdir -p "${save_in_folder}/failures"
    find . -type f -regex ".*/${directory}out/failures/delta-.*png" -exec cp {} "${save_in_folder}/failures" \;
  fi
done