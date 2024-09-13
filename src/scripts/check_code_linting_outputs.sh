#!/bin/bash

KOTLIN_FILE="src/.*/*.kt:"
OUTPUT_FOLDER=~/code_linting_outputs
OUTPUT_FILES=(
  "$OUTPUT_FOLDER/ktlint_output.txt"
  "$OUTPUT_FOLDER/detekt_output.txt"
)
OUTPUT_FAILURE=0

for OUTPUT_FILE in "${OUTPUT_FILES[@]}"; do
  FILE_NAME_WITH_EXTENSION=$(basename "$OUTPUT_FILE")
  OUTPUT_NAME=$(echo "${FILE_NAME_WITH_EXTENSION%_output.*}" | tr '[:lower:]' '[:upper:]')

  if grep -q "$KOTLIN_FILE" "$OUTPUT_FILE"; then
    OUTPUT=$(grep "$KOTLIN_FILE" "$OUTPUT_FILE")
    ISSUE_COUNT=$(echo "$OUTPUT" | wc -l | tr -d '[:space:]')
    echo -e "\n$OUTPUT_NAME found $ISSUE_COUNT issue(s):\n"

    ISSUES=()
    while IFS=$'\n' read -r issue; do
        ISSUES+=("$issue")
    done <<< "$OUTPUT"

    for ISSUE in "${ISSUES[@]}"; do
      echo -e "$ISSUE\n"
    done

    OUTPUT_FAILURE=1
  else
    echo -e "No $OUTPUT_NAME issue found."
  fi
done

if [ "$OUTPUT_FAILURE" -eq 1 ]; then
  echo "Code linting failed. You can access Sonar for quick access."
  exit 1
fi