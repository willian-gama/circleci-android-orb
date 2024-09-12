#!/bin/bash

# https://developer.android.com/studio/run/emulator-commandline
emulator -avd "$AVD_NAME" -no-audio -no-boot-anim -no-window -no-snapshot-save -verbose -wipe-data -gpu swiftshader_indirect