#!/bin/bash

if [ "$RUN_SCREENSHOT_TESTS" -eq 1 ]; then
  COMMAND=verifyPaparazzi"$BUILD_VARIANT" # It also runs unit tests: https://github.com/cashapp/paparazzi/issues/1161
  echo "Running unit/screenshot tests: $COMMAND"
else
  COMMAND=test"$BUILD_VARIANT"UnitTest
  echo "Running unit tests: $COMMAND"
fi

./gradlew "$COMMAND"