#!/bin/bash

./gradlew ktlintCheck
./gradlew detekt

case $BUILD_VARIANT in
  "debug") ./gradlew lintDebug;;
  "fullDebug") ./gradlew lintFullDebug;;
esac