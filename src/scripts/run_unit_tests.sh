#!/bin/bash

run_unit_tests() {
  echo "Running unit tests: $1"
  # shellcheck disable=SC2086 # Do not expand gradle command intentionally because it has spaces.
  ./gradlew $1
}

group_unit_tests_per_module() {
  unit_test_command=test${BUILD_VARIANT}UnitTest
  modules=$(
    echo "$SPLIT_UNIT_TEST_CLASS_NAMES" |
    awk '{
      for (i=1; i<=NF; i++) {
        sub(/\.com\..*/, "", $i)
        print($i)
      }
    }' |
    awk '!visited[$0]++' ORS=" "
  )

  IFS=' ' read -r -a modules <<< "$modules"

  for module in "${modules[@]}"; do
    unit_test_class_names=$(
      echo "$SPLIT_UNIT_TEST_CLASS_NAMES" |
      tr ' ' '\n' |
      awk "/^$module\./" |
      awk -F "^$module." '{ print("--tests", $2) }' ORS=" "
    )

    if [ -n "$unit_test_class_names" ]; then
      run_unit_tests "$module:$unit_test_command $unit_test_class_names"
    else
      echo "No unit test found for module: $module"
    fi
  done
}

group_unit_tests_per_module