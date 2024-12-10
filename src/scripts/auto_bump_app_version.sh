#!/bin/bash

if [ -f "app/build.gradle.kts" ]; then
  FILE="app/build.gradle.kts"
elif [ -f "app/build.gradle" ]; then
  FILE="app/build.gradle"
else
  echo "Neither build.gradle.kts nor build.gradle was found in app"
  exit 1
fi

set_new_version_name() {
  local local_version_name=$1
  local new_version_name=$2

  perl -i -pe "s/versionName[[:space:]]*=?[[:space:]]*\"$local_version_name\"/versionName \"$new_version_name\"/" "$FILE"
}

set_new_version_code() {
  local local_version_name=$1
  local new_version_name=$2

  IFS='.' read -r major minor patch <<< "$new_version_name"
  versionCode=$((major * 100000000 + minor * 100000 + patch * 1000))
  echo "$versionCode"

  perl -i -pe "s/versionCode[[:space:]]*=?[[:space:]]*([0-9]+)/versionCode $versionCode/" "$FILE"
}

get_current_version_name() {
  local content="$1"
  if [[ "$content" =~ versionName[[:space:]]*(=?)[[:space:]]*\"([0-9]+\.[0-9]+\.[0-9]+)(-[0-9]+)?\" ]]; then
    echo "${BASH_REMATCH[2]}"
    return 0
  else
    return 1
  fi
}

get_current_version_code() {
  local content="$1"
  if [[ "$content" =~ versionCode[[:space:]]*=?[[:space:]]*([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  else
    return 1
  fi
}

compare_versions() {
  local local_version_name=$1
  local remote_version_name=$2

  IFS="." read -r local_major local_minor local_patch <<< "$local_version_name"
  IFS="." read -r remote_major remote_minor remote_patch <<< "$remote_version_name"

  if [ "$local_major" -gt "$remote_major" ] || [ "$local_minor" -gt "$remote_minor" ] || [ "$local_patch" -gt "$remote_patch" ]; then
    return 1
  else
    return 0
  fi
}

bump_version_name() {
  local remote_version_name=$1
  IFS='.' read -r major minor patch <<< "$remote_version_name"
  echo "$major.$minor.$((patch + 1))"
}

push_new_version_to_git() {
  local local_version_name=$1
  local new_version_name=$2
  local commit_message="auto bump version from $local_version_name to $new_version_name"

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

  local_version_name=$(get_current_version_name "$local_file_content")
  remote_version_name=$(get_current_version_name "$remote_file_content")

  if compare_versions "$local_version_name" "$remote_version_name" -eq 0; then
    new_version_name=$(bump_version_name "$remote_version_name")
    local_version_code=$(get_current_version_code "$local_file_content")

    set_new_version_name "$local_version_name" "$new_version_name"
    set_new_version_code "$local_version_code" "$new_version_name"
    push_new_version_to_git "$local_version_name" "$new_version_name"
  else
    echo "local app version: $local_version_name is already greater than remote app version: $remote_version_name"
  fi
}

bump_version_if_needed