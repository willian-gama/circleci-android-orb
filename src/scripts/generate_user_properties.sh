#!/bin/bash

LOCAL_PROPERTIES="local.properties"
export LOCAL_PROPERTIES

if [ ! -f "$LOCAL_PROPERTIES" ]; then
    echo "Creating user properties file..."
    touch $LOCAL_PROPERTIES

    {
      echo "api_key=$API_KEY"
      echo "gpr_username=$GPR_USERNAME"
      echo "gpr_key=$GPR_KEY"
      echo "sonar_token=$SONAR_TOKEN"
    } >> $LOCAL_PROPERTIES

    cat $LOCAL_PROPERTIES
fi