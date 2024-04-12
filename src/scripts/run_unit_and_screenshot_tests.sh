#!/bin/bash

# It also runs unit tests: https://github.com/cashapp/paparazzi/issues/1161
COMMAND="verifyPaparazzi${BUILD_VARIANT}"
echo "$COMMAND"
./gradlew "$COMMAND"