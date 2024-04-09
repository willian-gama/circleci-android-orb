#!/bin/sh

# Custom checkout. Ref.: https://support.circleci.com/hc/en-us/articles/115015659247-How-do-I-modify-the-checkout-step#:~:text=If%20you%20need%20to%20change,process%20to%20suit%20your%20needs.&text=Please%20remember%20to%20remove%20the,step%20to%20process%20the%20checkout.
# CIRCLE_REPOSITORY_URL is not available with GitHub App authentication. Ref.: https://circleci.com/docs/variables/#built-in-environment-variables
# trigger_parameters.github_app.repo_url is available in Pipeline values - https://circleci.com/docs/variables/#pipeline-values
git clone -b "$CIRCLE_BRANCH" << pipeline.trigger_parameters.github_app.repo_url >> .