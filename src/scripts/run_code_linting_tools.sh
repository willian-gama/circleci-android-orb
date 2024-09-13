#!/bin/bash

OUTPUT_FOLDER=~/code_linting_outputs

if [ ! -d "$OUTPUT_FOLDER" ]; then
  mkdir "$OUTPUT_FOLDER"
fi

KTLINT_OUTPUT=$OUTPUT_FOLDER/ktlint_output.txt
./gradlew ktlintCheck > "$KTLINT_OUTPUT"
cat "$KTLINT_OUTPUT"

DETEKT_OUTPUT=$OUTPUT_FOLDER/detekt_output.txt
./gradlew detekt > "$DETEKT_OUTPUT"
cat "$DETEKT_OUTPUT"

./gradlew "lint$BUILD_VARIANT"
