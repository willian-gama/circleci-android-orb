#!/bin/bash

# HEADS-UP: Not being used

git clone -b main --depth=1 git@github.com:REPOSITORY.git ci
cp -rl ci/* ./
rm -rf ci