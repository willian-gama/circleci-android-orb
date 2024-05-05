#!/bin/bash

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
  # shellcheck disable=SC2086 # Do not expand intentionally because command has spaces.
  ./gradlew "$MODULE:test${BUILD_VARIANT}UnitTest" $UNIT_TEST_CLASS_NAMES
done