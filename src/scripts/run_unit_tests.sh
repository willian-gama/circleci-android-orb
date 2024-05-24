#!/bin/bash

# shellcheck disable=SC2086 # Do not expand gradle command intentionnally.
run_unit_tests() {
  echo "Running unit tests: $1"
  ./gradlew $1
}

group_unit_tests_per_module() {
  UNIT_TEST_COMMAND=test${BUILD_VARIANT}UnitTest
  MODULES=$(
    echo "$SPLIT_UNIT_TEST_CLASS_NAMES" |
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
    UNIT_TEST_CLASS_NAMES=$(
      echo "$SPLIT_UNIT_TEST_CLASS_NAMES" |
      awk "/^$MODULE\./" |
      awk '{
        for (i=1; i<=NF; i++) {
          sub(/^[^.]*\./, "", $i)
          print("--tests", $i)
        }
      }' ORS=" "
    )

    if [ -n "$UNIT_TEST_CLASS_NAMES" ]; then
      run_unit_tests "$MODULE:$UNIT_TEST_COMMAND $UNIT_TEST_CLASS_NAMES"
    fi
  done
}

group_unit_tests_per_module