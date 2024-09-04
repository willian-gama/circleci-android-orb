#!/bin/bash

if [ -z "$(git config --get user.name)" ]; then
  git config user.name "github-actions[bot]"
fi

if [ -z "$(git config --get user.email)" ]; then
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
fi

current_version=$(git describe --tags --abbrev=0)
IFS='.' read -r major minor patch <<< "$current_version"
new_version="$major.$minor.$((patch + 1))"

if ! git tag "$new_version" 2>/dev/null; then
  echo "Error when creating git tag: $new_version"
  exit 1
else
  echo "Bump version from $current_version to $new_version"
  git push origin "$new_version"
fi