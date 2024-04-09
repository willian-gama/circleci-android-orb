#!/bin/sh

gem install bundler
bundle check || bundle install --path vendor/bundle