#!/bin/bash

# Run locally in the Android Studio terminal for testing purposes: ./scripts/auto_bump.sh
if [ -f "build.gradle.kts" ]; then
  FILE="build.gradle.kts"
elif [ -f "build.gradle" ]; then
  FILE="build.gradle"
else
  echo "Neither build.gradle.kts nor build.gradle was found"
  exit 1
fi

set_new_version_number() {
  local local_version=$1
  local new_local_version=$2
  perl -i -pe "s/version *= *\"$local_version\"/version = \"$new_local_version\"/" "$FILE"
}

get_current_version_number() {
  local content="$1"
  if [[ "$content" =~ version\ *=\ *\"([0-9]+\.[0-9]+\.[0-9]+)\" ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  else
    return 1
  fi
}

compare_versions() {
  local local_version=$1
  local remote_version=$2

  IFS="." read -r local_major local_minor local_patch <<< "$local_version"
  IFS="." read -r remote_major remote_minor remote_patch <<< "$remote_version"

  if [ "$local_major" -gt "$remote_major" ] || [ "$local_minor" -gt "$remote_minor" ] || [ "$local_patch" -gt "$remote_patch" ]; then
    return 1
  else
    return 0
  fi
}

bump_remote_version() {
  local remote_version=$1
  IFS='.' read -r major minor patch <<< "$remote_version"
  echo "$major.$minor.$((patch + 1))"
}

push_new_version_to_git() {
  local local_version=$1
  local new_local_version=$2
  local commit_message="auto bump version from $local_version to $new_local_version"

  echo "$commit_message"

  if [ -z "$(git config --get user.name)" ]; then
    git config user.name "renovate[bot]"
  fi

  if [ -z "$(git config --get user.email)" ]; then
    git config user.email "29139614+renovate[bot]@users.noreply.github.com"
  fi

  git config --add --bool push.autoSetupRemote true # create a new branch automatically
  git add "$FILE"
  if ! git commit -m "$commit_message"; then
    echo "Error when committing the file $FILE"
    exit 1
  fi
  git push
}

bump_version_if_needed() {
  if ! local_file_content=$(cat "$FILE" 2>/dev/null); then
    echo "Local file $FILE could not be found or is empty"
    return 1
  fi

  if ! remote_file_content=$(git show origin/develop:"$FILE" 2>/dev/null); then
    echo "Remote file $FILE could not be found or is empty in the develop branch"
    return 1
  fi

  if ! local_version=$(get_current_version_number "$local_file_content"); then
    echo "Local version could not be found in the $FILE file"
    return 1
  fi

  if ! remote_version=$(get_current_version_number "$remote_file_content"); then
    echo "Remote version could not be found in the $FILE file"
    return 1
  fi

  if compare_versions "$local_version" "$remote_version" -eq 0; then
    new_local_version=$(bump_remote_version "$remote_version")
    set_new_version_number "$local_version" "$new_local_version"
    push_new_version_to_git "$local_version" "$new_local_version"
  else
    echo "local version: $local_version is already greater than remote version: $remote_version"
  fi
}

bump_version_if_needed