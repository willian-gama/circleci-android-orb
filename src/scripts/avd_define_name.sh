#!/bin/bash

AVD_NAME="TestAVD-$CIRCLE_NODE_INDEX"
AVD_DEVICE="pixel_3a_xl"
AVD_SYSTEM_IMAGE="system-images;android-34;google_apis;x86_64"

{
  echo "export AVD_NAME='$AVD_NAME'"
  echo "export AVD_DEVICE='$AVD_DEVICE'"
  echo "export AVD_SYSTEM_IMAGE='$AVD_SYSTEM_IMAGE'"
} >> "$BASH_ENV"