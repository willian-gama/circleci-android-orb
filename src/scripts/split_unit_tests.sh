#!/bin/bash

test_class_names=$(
  circleci tests glob "**/src/test/**/*.kt" "**/src/test/**/*.java" |
  circleci tests split --split-by=name --timings-type=classname
)

split_unit_test_class_names=()

for test_class in $test_class_names; do
  if grep -q "@Test" "$test_class" && ! grep -q "app.cash.paparazzi.Paparazzi" "$test_class"; then
    unit_test_class=$(
      echo "$test_class" |
      sed "s@/@.@g" |
      sed "s/src.test.kotlin.//" | sed "s/src.test.java.//" |
      sed "s/.kt//" | sed "s/.java//"
    )

    split_unit_test_class_names+=("$unit_test_class")
  fi
done

if [ ${#split_unit_test_class_names[@]} -gt 0 ]; then
  echo "export SPLIT_UNIT_TEST_CLASS_NAMES='${split_unit_test_class_names[*]}'" >> "$BASH_ENV"
  cat "$BASH_ENV"
else
  echo "No unit test classes found"
fi