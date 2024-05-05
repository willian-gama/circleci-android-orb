#!/bin/bash

cd ci || exit
gem install bundler
bundle config set path "vendor/bundle"
bundle check || bundle install