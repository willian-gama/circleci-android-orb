#!/bin/bash

ktlint_format_command=ktlintFormat

run_ktlint_format() {
  local ktlint_format_output=ktlint_format_output.txt
  local kotlin_file_pattern="src/.*/*.kt:"

  echo -e "Running ktlint format command: $ktlint_format_command\n"
  ./gradlew "$ktlint_format_command" > "$ktlint_format_output"
  cat "$ktlint_format_output"

  if grep -q "$kotlin_file_pattern" "$ktlint_format_output"; then
    output=$(grep "$kotlin_file_pattern" "$ktlint_format_output")
    issue_count=$(echo "$output" | wc -l | tr -d '[:space:]')
    echo -e "\n$ktlint_format_command cannot be auto-corrected $issue_count issue(s):\n"

    local issues=()
    while IFS=$'\n' read -r issue; do
        issues+=("$issue")
    done <<< "$output"

    for issue in "${issues[@]}"; do
      echo -e "$issue\n"
    done
  else
    echo -e "\nAll $ktlint_format_command issue(s) auto-corrected"
  fi
}

commit_changed_files() {
  if [ -z "$(git config --get user.name)" ]; then
    git config user.name "renovate[bot]"
  fi

  if [ -z "$(git config --get user.email)" ]; then
    git config user.email "29139614+renovate[bot]@users.noreply.github.com"
  fi

  modified_files=$(git status --porcelain | awk '/\.kt$/ { print $2 } ')

  if [ -n "$modified_files" ]; then
    count=$(echo "$modified_files" | wc -l | tr -d '[:space:]')
    echo -e "\nCommitting $count changed file(s):\n"
    echo -e "$modified_files\n"

    git add '*.kt'
    git commit -m "kotlin files updated with $ktlint_format_command"
    git push origin "$CIRCLE_BRANCH"
  else
    echo "No updates to commit"
  fi
}

run_ktlint_format
commit_changed_files