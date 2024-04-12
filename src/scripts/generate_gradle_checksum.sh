#!/bin/bash

run_with_retry() {
   echo "$UI_ASSEMBLE_COMMAND"
   $UI_ASSEMBLE_COMMAND
}

run_with_retry