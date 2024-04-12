#!/bin/bash

COMMAND="test${BUILD_VARIANT}UnitTest"
echo "$COMMAND"
./gradlew "$COMMAND"