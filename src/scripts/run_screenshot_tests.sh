#!/bin/bash

run_screenshot_tests() {
  echo "Running screenshot tests: $1"
  # shellcheck disable=SC2086 # Do not expand gradle command intentionally because it has spaces.
  ./gradlew $1
}

group_screenshot_tests_per_module() {
  screenshot_test_command=verifyPaparazzi${BUILD_VARIANT}
  modules=$(
    echo "$SPLIT_SCREENSHOT_TEST_CLASS_NAMES" |
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
    screenshot_test_class_names=$(
      echo "$SPLIT_SCREENSHOT_TEST_CLASS_NAMES" |
      tr ' ' '\n' |
      awk "/^$module\./" |
      awk -F "^$module." '{ print("--tests", $2) }' ORS=" "
    )

    if [ -n "$screenshot_test_class_names" ]; then
      run_screenshot_tests "${module//\./:}:$screenshot_test_command $screenshot_test_class_names"
    else
      echo "No screenshot test found for module: $module"
    fi
  done
}

group_screenshot_tests_per_module