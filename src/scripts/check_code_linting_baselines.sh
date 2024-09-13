#!/bin/bash

error_code=0
detekt_baselines=()
ktlint_baselines=()
android_baselines=()

group_baselines() {
  baseline_files=$(find . -type f -path "*/baseline/*/baseline.xml")

  for baseline_file in $baseline_files; do
    file=${baseline_file#./}

    if grep -q "<<<<<<< HEAD" "$file"; then
      if [[ "$file" == *"baseline/detekt/baseline.xml" ]]; then
        detekt_baselines+=("$file")
      elif [[ "$file" == *"baseline/ktlint/baseline.xml" ]]; then
        ktlint_baselines+=("$file")
      elif [[ "$file" == *"baseline/androidlint/baseline.xml" ]]; then
        android_baselines+=("$file")
      fi
      error_code=1
    fi
  done
}

print_baseline_error_messages() {
  echo "Error found when validating baselines"

  if [ ${#detekt_baselines[@]} -gt 0 ]; then
    echo -e "\nDelete and regenerate ${#detekt_baselines[@]} detekt baseline(s):\n"
    for baseline in "${detekt_baselines[@]}"; do
      echo "- $baseline"
    done
  fi

  if [ ${#ktlint_baselines[@]} -gt 0 ]; then
    echo -e "\nDelete and regenerate ${#ktlint_baselines[@]} ktlint baseline(s):\n"
    for baseline in "${ktlint_baselines[@]}"; do
      echo "- $baseline"
    done
  fi

  if [ ${#android_baselines[@]} -gt 0 ]; then
    echo -e "\nDelete and regenerate ${#android_baselines[@]} android lint baseline(s):\n"
    for baseline in "${android_baselines[@]}"; do
      echo "- $baseline"
    done
  fi
}

group_baselines

if [ "$error_code" -eq 1 ]; then
  print_baseline_error_messages
  exit 1
else
  echo "Baseline(s) file(s) validated successfully"
fi