#!/bin/bash
cd $1
PRITTY_DIR="$(pwd | sed 's:/: :g' | awk '{ print $NF }')"
GIT_STATUS="$(git status --porcelain)"
UNPUSHED_COMMITS="$(git push --dry-run 2>&1 | grep 'Everything up-to-date')"
GIT_PULL="$(git pull --dry-run 2>&1)"
CLEAN_DIR="TRUE"

send-notification ()
{
    XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send "$1" "$2" $3 $4 
}

UNCOMITTED_STRING=""
if [[ "$GIT_STATUS" != "" ]]; then
    UNCOMITTED_STRING="Uncommited changes\n"
    CLEAN_DIR="FALSE"
fi

UNPUSHED_STRING=""
if [[ "$UNPUSHED_COMMITS" != "Everything up-to-date" ]]; then
    UNPUSHED_STRING="Unpushed commits\n"
    CLEAN_DIR="FALSE"
fi

UNPULLED_STRING=""
if [[ "$GIT_PULL" != "" ]]; then
    UNPULLED_STRING="New commits to pull\n"
    CLEAN_DIR="FALSE"
fi

if [[ "$CLEAN_DIR" == "FALSE" ]]; then
    BODY="$UNCOMITTED_STRING $UNPUSHED_STRING $UNPULLED_STRING"
    send-notification "$PRITTY_DIR is not up to date" "$BODY" --urgency=critical --expire-time="$2"
fi
