#!/bin/bash

GIT_BRANCH=$CIRCLE_BRANCH
# Github client: https://cli.github.com/manual/gh_pr_view
PR_BRANCHES=$(gh pr list --state open --base "$GIT_BRANCH" --json headRefName,isDraft --jq ".[] | select(.isDraft == false) | .headRefName")

if [ -z "$(git config --get user.name)" ]; then
  git config user.name "github-actions[bot]"
fi

if [ -z "$(git config --get user.email)" ]; then
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
fi

if [ -n "$PR_BRANCHES" ]; then
  for branch in $PR_BRANCHES; do
    echo -e "\n- Syncing branches: $branch with $GIT_BRANCH\n"

    git checkout "$branch"
    git pull origin "$branch"

    if git merge "origin/$GIT_BRANCH" --no-edit > /dev/null 2>&1; then
      git push origin "$branch"
      echo -e "Branch: $branch has synced successfully"
    else
      git merge --abort
      echo -e "Branch: $branch has conflicts that must be resolved"
    fi
  done
else
  echo "No PRs available for the target branch: $GIT_BRANCH"
fi