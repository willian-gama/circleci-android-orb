#!/bin/bash

# https://developer.android.com/tools/sdkmanager
sdkmanager "$AVD_SYSTEM_IMAGE"

# https://developer.android.com/tools/avdmanager
avdmanager --verbose create avd --name "$AVD_NAME" --package "$AVD_SYSTEM_IMAGE" --device "$AVD_DEVICE"
echo "$AVD_NAME created with the device $AVD_DEVICE using $AVD_SYSTEM_IMAGE"