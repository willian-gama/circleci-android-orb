#!/bin/bash

ui_test_failure=0

run_ui_tests_with_retry() {
  tries=1
  until [ $tries -gt "$MAX_TRIES" ]; do
    echo "Starting test attempt $tries with command $1 $2"
    ./gradlew "$1" "$2" && break
    tries=$((tries+1))
    sleep "$RETRY_INTERVAL"
  done

  if [ $tries -gt "$MAX_TRIES" ]; then
    echo "Max tries reached ($MAX_TRIES)"
    ui_test_failure=1
  fi
}

group_ui_tests_per_module() {
  ui_test_command=connected${BUILD_VARIANT}AndroidTest
  modules=$(
    echo "$SPLIT_UI_TEST_CLASS_NAMES" |
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
    ui_test_class_names=$(
      echo "$SPLIT_UI_TEST_CLASS_NAMES" |
      tr ' ' '\n' |
      awk "/^$module\./" |
      awk -F "^$module." '{ print($2) }' ORS=","
    )

    if [ -n "$ui_test_class_names" ]; then
      run_ui_tests_with_retry "${module//\./:}:$ui_test_command" "-Pandroid.testInstrumentationRunnerArguments.class=$ui_test_class_names"
    else
      echo "No UI test found for module: $module"
    fi
  done
}

group_ui_tests_per_module

if [ "$ui_test_failure" -eq 1 ]; then
  echo "UI test failed"
  exit 1
fi