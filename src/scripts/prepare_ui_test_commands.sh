#!/bin/bash

case $BUILD_VARIANT in
  "debug")
    {
        echo "export UI_ASSEMBLE_COMMAND='assembleDebugAndroidTest'"
        echo "export UI_TEST_COMMAND='connectedDebugAndroidTest'"
    } >> "$BASH_ENV"
  ;;
  "fullDebug")
    {
        echo "export UI_ASSEMBLE_COMMAND='assembleFullDebugAndroidTest'"
        echo "export UI_TEST_COMMAND='connectedFullDebugAndroidTest'"
    } >> "$BASH_ENV"
  ;;
esac

echo "$UI_ASSEMBLE_COMMAND"
echo "$UI_TEST_COMMAND"