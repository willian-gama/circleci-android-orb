#!/bin/bash

UI_TEST_FAILURE=0

run_ui_tests_with_retry() {
  TRIES=1
  until [ $TRIES -gt "$MAX_TRIES" ]; do
    echo "Starting test attempt $TRIES with command $1 $2"
    ./gradlew "$1" "$2" && break
    TRIES=$((TRIES+1))
    sleep "$RETRY_INTERVAL"
  done

  if [ $TRIES -gt "$MAX_TRIES" ]; then
    echo "Max tries reached ($MAX_TRIES)"
    UI_TEST_FAILURE=1
  fi
}

group_ui_tests_per_module() {
  MODULES=$(
    echo "$SPLIT_UI_TEST_CLASS_NAMES" |
    awk '{
      for (i=1; i<=NF; i++) {
        sub(/\..*/, "", $i)
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
      awk '{
        for (i=1; i<=NF; i++) {
          sub(/^[^.]*\./, "", $i)
          print($i)
        }
      }' ORS=","
   )
   run_ui_tests_with_retry "$MODULE:connected${BUILD_VARIANT}AndroidTest" "-Pandroid.testInstrumentationRunnerArguments.class=$UI_TEST_CLASS_NAMES"
  done
}

group_ui_tests_per_module

if [ "$UI_TEST_FAILURE" -eq 1 ]; then
  echo "UI test failed"
  exit 1
fi