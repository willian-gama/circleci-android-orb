#!/bin/bash
set -euo pipefail
# File path to the build.gradle
file="build.gradle"

# Function to increment version number
increment_version() {
  local parts
  local version=$1
  local IFS=.
  read -r -a parts <<<"$version"
  parts[2]=$((parts[2] + 1)) # Increment patch version
  echo "${parts[0]}.${parts[1]}.${parts[2]}"
}

# Function to compare 2 versions, and bumps accordingly
compare_versions() {
  local remote_version=$1
  local local_version=$2

  local remote_major
  local remote_minor
  local remote_patch

  local local_major
  local local_minor
  local local_patch

  echo "Comparing remote version: $remote_version and local version: $local_version"

  IFS=. read -r remote_major remote_minor remote_patch <<<"$remote_version"
  IFS=. read -r local_major local_minor local_patch <<<"$local_version"
  #Remote major version is HIGHER than local, it _has_ to be the higher version
  if [[ $remote_major -gt $local_major ]]; then
    echo "Remote major version is higher than local version"
    bump_version "$remote_version" "$local_version"
    return 0
  #Local major version is HIGHER than remote, it _has_ to be the higher version
  elif [[ $remote_major -lt $local_major ]]; then
    echo "Local major version is higher than remote version, no need to bump"
    return 1
  fi
  # Major versions were the same, comparing minor versions with the same logic
  if [[ $remote_minor -gt $local_minor ]]; then
    echo "Remote minor version is higher than local version"
    bump_version "$remote_version" "$local_version"
    return 0
  elif [[ $remote_minor -lt $local_minor ]]; then
    echo "Local minor version is higher than remote version, no need to bump"
    return 1
  fi
  # Minor versions were the same, comparing patch versions
  if [[ $remote_patch -gt $local_patch ]]; then
    echo "Remote patch version is higher than local version"
    bump_version "$remote_version" "$local_version"
    return 0
  elif [[ $remote_patch -lt $local_patch ]]; then
    echo "Local patch version is higher than remote version, no need to bump"
    return 1
  fi

  echo "The local and the remote versions are identical, bumping"
  bump_version "$local_version" "$local_version"
  return 0
}

# Function to actually bump the version
bump_version() {
  local version_to_bump=$1
  local current_version=$2
  local new_version
  new_version=$(increment_version "$version_to_bump")
  # A check to allow for this script to be run on a Mac machine as well, since there no need for a suffix for the backup file
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/$current_version/$new_version/" "$file"
  else
    sed -i "s/$current_version/$new_version/" "$file"
  fi
  echo "Updated pom_version_name from $current_version to $new_version"
}

# Function to get the version number from a file
get_version_number() {
  local file=$1
  local line

  while IFS= read -r line; do
    if [[ "$line" =~ pom_version_name\ *=\ *\"([0-9]+\.[0-9]+\.[0-9]+)\" ]]; then
      echo "${BASH_REMATCH[1]}"
      return 0
    fi
  done <<< "$file"
  echo "Failed to find the line with the version number"
  return 1
}

# Function to commit the changes that were done
commit_bump() {
  # Set the git config
  git config user.name "${DEPLOYMENT_USER}"
  git config user.email "${DEPLOYMENT_EMAIL}"
  git config --add --bool push.autoSetupRemote true
  # Add file
  git add "$file"
  # Commit the change
  git commit -m "[ci skip] pom version bumped"
  # Push it
  git push
}

bump_version_if_needed() {
  local local_version
  local remote_version
  local_version=$(get_version_number "$(cat "$file")")
  echo "Local version: $local_version"
  remote_version=$(get_version_number "$(git show main:"$file")")

  echo "Remote version: $remote_version"
  # Compare versions and bump if needed
  if compare_versions "$remote_version" "$local_version"; then
    commit_bump
    exit 0
  fi
  exit 0
}

bump_version_if_needed
