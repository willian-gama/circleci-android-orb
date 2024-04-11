#!/bin/bash

mkdir -p ~/test-results/unit-tests/
find . -type f -regex ".*/build/test-results/.*xml" -exec cp {} ~/test-results/unit-tests/ \;