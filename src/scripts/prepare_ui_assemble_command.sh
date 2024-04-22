#!/bin/bash

COMMAND=assemble"$BUILD_VARIANT"AndroidTest
echo "export UI_ASSEMBLE_COMMAND=$COMMAND" >> "$BASH_ENV"