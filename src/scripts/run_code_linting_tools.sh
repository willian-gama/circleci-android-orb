#!/bin/bash

case $BUILD_VARIANT in
  "debug") ./gradlew ktlintCheck detektDebug detektDebugUnitTest detektDebugAndroidTest lintDebug;;
  "fullDebug") ./gradlew ktlintCheck detektFullDebug detektFullDebugUnitTest detektFullDebugAndroidTest lintFullDebug;;
esac