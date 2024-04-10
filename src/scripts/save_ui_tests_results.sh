#!/bin/sh

mkdir -p ~/test-results/ui-tests/
find . -type f -regex ".*/build/outputs/androidTest-results/connected/.*xml" -exec cp {} ~/test-results/ui-tests/ \;