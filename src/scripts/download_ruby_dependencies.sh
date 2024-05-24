#!/bin/bash

gem install bundler
bundle config set path "vendor/bundle"
bundle check || bundle install