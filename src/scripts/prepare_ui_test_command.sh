#!/bin/bash

case $BUILD_VARIANT in
  "debug") COMMAND="connectedDebugAndroidTest" ;;
  "fullDebug") COMMAND="connectedFullDebugAndroidTest" ;;
esac

echo "export UI_TEST_COMMAND=$COMMAND" >> "$BASH_ENV"
source "$BASH_ENV"