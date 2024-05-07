#!/bin/bash

ANDROID_CACHE_ARGS='. -name "build.gradle*" -o -name "gradle-wrapper.properties" -o -name "settings.gradle*"'
echo "export ANDROID_CACHE_ARGS=$ANDROID_CACHE_ARGS" >> "$BASH_ENV"
cat "$BASH_ENV"