#!/bin/sh
set -e

# Make a nice shell logger, thank you Filippo
__() { printf "\n\033[1;32m* %s [%s]\033[0m\n" "$1" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"; }

# If the folder is mapped from the outside, the user will mismatch, ignore
git config --global --add safe.directory /workdir

# Clone the repository if new, or update if already exists
if [ ! -e /workdir/.git ]; then
    if [ ! "$GITHUB_AUTH" = "" ]; then
        __ "Cloning private repo $GITHUB_USER/$GITHUB_REPO"
        git clone "https://$GITHUB_AUTH@github.com/$GITHUB_USER/$GITHUB_REPO" /workdir
    else
        __ "Cloning public repo $GITHUB_USER/$GITHUB_REPO"
        git clone "https://github.com/$GITHUB_USER/$GITHUB_REPO" /workdir
    fi
fi
__ "Fetching updates from $GITHUB_USER/$GITHUB_REPO"
cd /workdir
git fetch

# Switch to whichever branch was requested and update it
if [ ! "$RUNME_BRANCH" = "" ]; then
    __ "Switching branch to $RUNME_BRANCH"
    git checkout "$RUNME_BRANCH"
fi
__ "Pulling upstream changes"
git pull

# Switch execution over to the user code
if [ "$RUNME_TYPE" = "shell" ]; then
    __ "Executing shell at $RUNME_TARGET"
    (cd "$(dirname "$RUNME_TARGET")" && sh "$(basename "$RUNME_TARGET")")
fi
if [ "$RUNME_TYPE" = "golang" ]; then
    __ "Executing Go at $RUNME_TARGET"
    if [ -f "$RUNME_TARGET" ]; then
        (cd "$(dirname "$RUNME_TARGET")" && go run "$(basename "$RUNME_TARGET")")
    else
        (cd "$RUNME_TARGET" && go run "./")
    fi
fi
if [ "$RUNME_TYPE" = "rust" ]; then
    __ "Executing Rust at $RUNME_TARGET"
    (cd "$RUNME_TARGET" && cargo run)
fi
