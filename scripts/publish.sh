#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-wisp-pi-zero-w-image}"

command -v gh >/dev/null || {
    echo "GitHub CLI is required: https://cli.github.com/"
    exit 1
}

gh auth status >/dev/null

CURRENT_BRANCH=$(git symbolic-ref --quiet --short HEAD) || {
    echo "Not on a branch; check out main first."
    exit 1
}

if git remote get-url origin >/dev/null 2>&1; then
    echo "Remote 'origin' already exists."
    exit 1
fi

if [ "$CURRENT_BRANCH" != "main" ]; then
    if git show-ref --verify --quiet refs/heads/main; then
        echo "Branch 'main' already exists; refusing to overwrite it."
        echo "Rename or merge '$CURRENT_BRANCH' manually."
        exit 1
    fi
    git branch -m "$CURRENT_BRANCH" main
fi

gh repo create "$REPO" --public --source=. --remote=origin --push
echo "Created and pushed https://github.com/$(gh api user --jq .login)/$REPO"
