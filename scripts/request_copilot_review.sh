#!/bin/bash

# Helper script to request a GitHub Copilot review for a PR
# Usage: request_copilot_review.sh <pr_number> [repo]

PR_NUMBER="$1"
REPO="${2:-shop/world}"

if [ -z "$PR_NUMBER" ]; then
    echo "Error: PR number is required"
    echo "Usage: $0 <pr_number> [repo]"
    exit 1
fi

echo "🤖 Requesting GitHub Copilot review for PR #$PR_NUMBER in $REPO..."

# Check if gh CLI is authenticated
if ! gh auth status >/dev/null 2>&1; then
    echo "❌ Not authenticated with GitHub CLI"
    echo "Please run: gh auth login"
    exit 1
fi

# Use GitHub API to request a Copilot review
# This uses the GitHub PR review request API
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/$REPO/pulls/$PR_NUMBER/requested_reviewers" \
  -f "reviewers[]=copilot" 2>/dev/null

# Alternative: Add a comment mentioning @copilot
gh pr comment "$PR_NUMBER" --repo "$REPO" --body "@copilot Please review this PR" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ Copilot review requested successfully!"
    echo "Opening PR in browser..."
    gh pr view "$PR_NUMBER" --repo "$REPO" --web
else
    echo "⚠️  Added review comment. Opening PR..."
    gh pr view "$PR_NUMBER" --repo "$REPO" --web
fi
