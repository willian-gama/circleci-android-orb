#!/bin/bash

if [ "$RUN_SCREENSHOT_TESTS" = true ]; then
  ./gradlew verifyPaparazzi"$BUILD_VARIANT" # It also runs unit tests: https://github.com/cashapp/paparazzi/issues/1161
else
  ./gradlew test"$BUILD_VARIANT"UnitTest
fi