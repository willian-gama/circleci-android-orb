#!/bin/bash

ASSEMBLE_TEST_COMMAND=assemble"$BUILD_VARIANT"AndroidTest
UI_ASSEMBLE_COMMAND=$(
  echo "$SPLIT_UI_TEST_CLASS_NAMES" |
  awk -v ASSEMBLE_TEST_COMMAND="$ASSEMBLE_TEST_COMMAND" '{
    for (i=1; i<=NF; i++) {
      sub(/\.com\..*/, "", $i)
      print($i":"ASSEMBLE_TEST_COMMAND)
    }
  }' |
  awk '!visited[$0]++' ORS=" "
)

echo "export UI_ASSEMBLE_COMMAND='$UI_ASSEMBLE_COMMAND'" >> "$BASH_ENV"
cat "$BASH_ENV"