#!/bin/bash

gem install bundler
bundle check || bundle install --path vendor/bundle