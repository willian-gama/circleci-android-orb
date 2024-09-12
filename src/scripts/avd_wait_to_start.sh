#!/bin/bash

if timeout 30s circle-android wait-for-boot; then
  echo "Emulator has booted successfully"
else
  echo "Emulator boot wait timed out"
  exit 1
fi