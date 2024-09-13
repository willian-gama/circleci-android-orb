#!/bin/bash

UI_TEST_FAILURE=0

run_ui_tests_with_retry() {
  TRIES=1
  until [ $TRIES -gt "$MAX_TRIES" ]; do
    echo "Starting test attempt $TRIES with command $1"
    # shellcheck disable=SC2086 # Do not expand gradle command intentionally because it has spaces.
    ./gradlew $1 && break
    TRIES=$((TRIES+1))
    sleep "$RETRY_INTERVAL"
  done

  if [ $TRIES -gt "$MAX_TRIES" ]; then
    echo "Max tries reached ($MAX_TRIES)"
    UI_TEST_FAILURE=1
  fi
}

group_ui_tests_per_module() {
  UI_TEST_COMMAND=connected${BUILD_VARIANT}AndroidTest
  MODULES=$(
    echo "$SPLIT_UI_TEST_CLASS_NAMES" |
    awk '{
      for (i=1; i<=NF; i++) {
        sub(/\.com\..*/, "", $i)
        print($i)
      }
    }' |
    awk '!visited[$0]++' ORS=" "
  )

  read -r -a MODULES <<< "$MODULES"

  for MODULE in "${MODULES[@]}"; do
    UI_TEST_CLASS_NAMES=$(
      echo "$SPLIT_UI_TEST_CLASS_NAMES" |
      awk "/^$MODULE\./" |
      awk -F "^$MODULE." '{
        print($2)
      }' ORS=","
    )

    if [ -n "$UI_TEST_CLASS_NAMES" ]; then
      run_ui_tests_with_retry "${MODULE//\./:}:$UI_TEST_COMMAND -Pandroid.testInstrumentationRunnerArguments.class=$UI_TEST_CLASS_NAMES"
    fi
  done
}

group_ui_tests_per_module

if [ "$UI_TEST_FAILURE" -eq 1 ]; then
  echo "UI test failed"
  exit 1
fi