#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-wisp-pi-zero-w-image}"

command -v gh >/dev/null || {
    echo "GitHub CLI is required: https://cli.github.com/"
    exit 1
}

gh auth status >/dev/null

if git remote get-url origin >/dev/null 2>&1; then
    echo "Remote 'origin' already exists."
    exit 1
fi

gh repo create "$REPO" --public --source=. --remote=origin --push
echo "Created and pushed https://github.com/$(gh api user --jq .login)/$REPO"
