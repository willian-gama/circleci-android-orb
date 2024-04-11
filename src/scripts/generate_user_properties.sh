#!/bin/bash

USER_PROPERTIES="user.properties"
export USER_PROPERTIES

if [ ! -f "$USER_PROPERTIES" ]; then
    echo "Creating user properties file..."
    touch $USER_PROPERTIES

    {
      echo "maven_repo_url=$MAVEN_REPO_URL"
      echo "maven_repo_username=$MAVEN_REPO_USERNAME"
      echo "maven_repo_access_token=$MAVEN_REPO_ACCESS_TOKEN"
      echo "sonar_token=$SONAR_TOKEN"
      echo "sonar_project_key=$SONAR_PROJECT_KEY"
      echo "sonar_organization_key=$SONAR_ORGANIZATION_KEY"
      echo "sonar_analysis=$SONAR_ANALYSIS"
    } >> $USER_PROPERTIES

    cat $USER_PROPERTIES
fi