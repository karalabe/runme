#!/bin/sh
set -e

# Clone the repository if new, or update if already exists
if [ ! -e workdir ]; then
    if [ ! "$GITHUB_AUTH" = "" ]; then
        git clone "https://$GITHUB_AUTH@github.com/$GITHUB_USER/$GITHUB_REPO" workdir
    else
        git clone "https://github.com/$GITHUB_USER/$GITHUB_REPO" workdir
    fi
fi
cd workdir
git fetch

# Switch to whichever branch was requested and update it
if [ ! "$GIT_BRANCH" = "" ]; then
    git checkout "$GIT_BRANCH"
fi
git pull

# Switch execution over to the user code
if [ "$RUNME_TYPE" = "shell" ]; then
    (cd "$(dirname "$1")" && sh "$(basename "$1")")
fi
if [ "$RUNME_TYPE" = "golang" ]; then
    (cd "$(dirname "$1")" && go run "$(basename "$1")")
fi
if [ "$RUNME_TYPE" = "rust" ]; then
    (cd "$1" && cargo run)
fi
