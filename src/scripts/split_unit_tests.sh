#!/bin/bash

SPLIT_UNIT_TEST_CLASS_NAMES=$(
  circleci tests glob "**/src/test/**/*Test.kt" "**/src/test/**/*Test.java" |
  sed "s@/@.@g" |
  sed "s/src.test.kotlin.//" | sed "s/src.test.java.//" |
  sed "s/.kt//" | sed "s/.java//" |
  circleci tests split --split-by=name --timings-type=classname
)

echo "export SPLIT_UNIT_TEST_CLASS_NAMES='$SPLIT_UNIT_TEST_CLASS_NAMES'" >> "$BASH_ENV"
cat "$BASH_ENV"