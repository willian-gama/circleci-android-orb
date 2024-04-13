#!/bin/bash

ASSEMBLE_COMMAND=assemble"$BUILD_VARIANT"AndroidTest
TEST_COMMAND=connected"$BUILD_VARIANT"AndroidTest

{
    echo "export UI_ASSEMBLE_COMMAND=$ASSEMBLE_COMMAND"
    echo "export UI_TEST_COMMAND=$TEST_COMMAND"
} >> "$BASH_ENV"

cat "$BASH_ENV"