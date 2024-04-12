#!/bin/bash

COMMAND="ktlintCheck detekt lint${BUILD_VARIANT}"
echo "$COMMAND"
./gradlew "$COMMAND"