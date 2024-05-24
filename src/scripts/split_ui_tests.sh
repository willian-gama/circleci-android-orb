#!/bin/bash

SPLIT_UI_TEST_CLASS_NAMES=$(
  circleci tests glob "**/src/androidTest/**/*Test.kt" "**/src/androidTest/**/*Test.java" |
  sed "s@/@.@g" |
  sed "s/src.androidTest.kotlin.//" | sed "s/src.androidTest.java.//" |
  sed "s/.kt//" | sed "s/.java//" |
  circleci tests split --split-by=name --timings-type=classname
)

echo "export SPLIT_UI_TEST_CLASS_NAMES='$SPLIT_UI_TEST_CLASS_NAMES'" >> "$BASH_ENV"
cat "$BASH_ENV"