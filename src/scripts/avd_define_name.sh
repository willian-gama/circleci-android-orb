#!/bin/bash

AVD_NAME=TestAVD-$CIRCLE_NODE_INDEX

echo "AVD_NAME=$AVD_NAME"
echo "export AVD_NAME='$AVD_NAME'" >> "$BASH_ENV"