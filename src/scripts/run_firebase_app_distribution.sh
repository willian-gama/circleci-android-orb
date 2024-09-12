#!/bin/bash

COMMAND="assemble$BUILD_VARIANT appDistributionUpload$BUILD_VARIANT"
# shellcheck disable=SC2086 # Do not expand gradle command intentinally because it has spaces.
./gradlew $COMMAND