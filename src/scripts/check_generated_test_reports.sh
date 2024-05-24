#!/bin/bash

# HEADS-UP: Not being used

for directory in */; do
  if test -d "$directory/build/outputs/unit_test_code_coverage" || test -d "$directory/build/outputs/code_coverage"; then
    echo "Unit/ui tests reports found"
    exit
  fi
done

echo "Halting this container, no code coverage to process"
circleci-agent step halt