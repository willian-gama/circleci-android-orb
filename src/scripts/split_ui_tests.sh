#!/bin/bash

test_class_names=$(
  circleci tests glob "**/androidTest/**/*.kt" "**/androidTest/**/*.java" |
  circleci tests split --split-by=name --timings-type=classname
)

split_ui_test_class_names=()

for test_class in $test_class_names; do
  if grep -q "@Test" "$test_class"; then
    ui_test_class=$(
      echo "$test_class" |
      sed "s@/@.@g" |
      sed "s/src.androidTest.kotlin.//" | sed "s/src.androidTest.java.//" |
      sed "s/.kt//" | sed "s/.java//"
    )

    split_ui_test_class_names+=("$ui_test_class")
  fi
done

echo "export SPLIT_UI_TEST_CLASS_NAMES='${split_ui_test_class_names[*]}'" >> "$BASH_ENV"
cat "$BASH_ENV"