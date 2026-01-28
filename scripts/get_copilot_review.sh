#!/bin/bash

# Get a GitHub Copilot review privately without leaving public comments
# Usage: get_copilot_review.sh <pr_number> [repo]

set -e

PR_NUMBER="$1"
REPO="${2:-shop/world}"

if [ -z "$PR_NUMBER" ]; then
    echo "Error: PR number is required"
    echo "Usage: $0 <pr_number> [repo]"
    exit 1
fi

echo "🤖 Requesting private Copilot review for PR #$PR_NUMBER in $REPO..."

# Step 1: Post a comment to trigger Copilot review
echo "📝 Posting review request comment..."
COMMENT_RESPONSE=$(gh pr comment "$PR_NUMBER" --repo "$REPO" --body "@copilot Please review this PR" 2>&1)
COMMENT_URL=$(echo "$COMMENT_RESPONSE" | grep -o 'https://github.com/[^[:space:]]*')
COMMENT_ID=$(echo "$COMMENT_URL" | grep -o '[0-9]*$')

if [ -z "$COMMENT_ID" ]; then
    echo "❌ Failed to post comment"
    exit 1
fi

echo "✅ Comment posted (ID: $COMMENT_ID)"

# Step 2: Wait for Copilot to respond (poll for new comments)
echo "⏳ Waiting for Copilot response (max 60 seconds)..."
MAX_ATTEMPTS=30
ATTEMPT=0
COPILOT_RESPONSE=""

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    ATTEMPT=$((ATTEMPT + 1))
    
    # Get recent comments after our comment
    RECENT_COMMENTS=$(gh api "/repos/$REPO/issues/$PR_NUMBER/comments?per_page=10&sort=created&direction=desc" 2>/dev/null || echo "[]")
    
    # Look for Copilot's response (user login is "copilot" or similar)
    COPILOT_RESPONSE=$(echo "$RECENT_COMMENTS" | jq -r '.[] | select(.user.login | test("copilot"; "i")) | select(.id > '"$COMMENT_ID"') | .body' | head -1)
    
    if [ -n "$COPILOT_RESPONSE" ]; then
        echo "✅ Copilot responded!"
        break
    fi
    
    echo -n "."
done

echo ""

# Step 3: Delete our trigger comment to keep PR clean
echo "🧹 Cleaning up trigger comment..."
gh api -X DELETE "/repos/$REPO/issues/comments/$COMMENT_ID" 2>/dev/null || echo "⚠️ Could not delete comment"

# Step 4: Output the review
if [ -n "$COPILOT_RESPONSE" ]; then
    echo "---COPILOT_REVIEW_START---"
    echo "$COPILOT_RESPONSE"
    echo "---COPILOT_REVIEW_END---"
    exit 0
else
    echo "⏱️ Copilot did not respond within timeout period"
    echo "---COPILOT_REVIEW_START---"
    echo "Copilot did not respond within the timeout period. This might mean:"
    echo "- Copilot is busy or unavailable"
    echo "- The PR is too large or complex"
    echo "- There was a network issue"
    echo ""
    echo "Please try again or visit the PR directly to request a review."
    echo "---COPILOT_REVIEW_END---"
    exit 0
fi
