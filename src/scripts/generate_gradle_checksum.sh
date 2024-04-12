#!/bin/bash

run_with_retry() {
   echo "$PARAM_PRE_TEST_COMMAND"
   $PARAM_PRE_TEST_COMMAND
}

run_with_retry