#!/bin/bash

case $BUILD_VARIANT in
  "debug") COMMAND="assembleDebugAndroidTest" ;;
  "fullDebug") COMMAND="assembleFullDebugAndroidTest" ;;
esac

echo "export UI_ASSEMBLE_COMMAND=$COMMAND" >> "$BASH_ENV"
source "$BASH_ENV"