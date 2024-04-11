#!/bin/bash

 # It also runs unit tests: https://github.com/cashapp/paparazzi/issues/1161
case $BUILD_VARIANT in
  "debug") ./gradlew testDebugUnitTest;;
  "fullDebug") ./gradlew testFullDebugUnitTest;;
esac