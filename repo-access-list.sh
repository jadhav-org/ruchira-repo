#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <repo_owner> <repo_name>"
    exit 1
fi

# Assign arguments to variables
REPO_OWNER=$1
REPO_NAME=$2

# Check if the environment variables for GitHub username and token are set
if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Please set GITHUB_USERNAME and GITHUB_TOKEN environment variables."
    exit 1
fi

# Fetch the list of collaborators
response=$(curl -s -u "$GITHUB_USERNAME:$GITHUB_TOKEN" \
    "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/collaborators")

# Check if the response contains an error message
if echo "$response" | jq -e 'has("message")' > /dev/null; then
    echo "Error: $(echo "$response" | jq -r '.message')"
    exit 1
fi

# Extract and display the list of collaborators
echo "Users with access to the repository '$REPO_OWNER/$REPO_NAME':"
echo "$response" | jq -r '.[].login'
