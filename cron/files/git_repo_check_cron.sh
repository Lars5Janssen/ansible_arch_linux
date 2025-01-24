#!/bin/bash
# TODO REFACTOR FUNCTION OUT
MINWAIT=1
MAXWAIT=300
SLEEP_DUR=$((MINWAIT+RANDOM % (MAXWAIT-MINWAIT)))
sleep $SLEEP_DUR
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

BODY=""
if [[ "$CLEAN_DIR" == "FALSE" ]]; then
    BODY="$UNCOMITTED_STRING $UNPUSHED_STRING $UNPULLED_STRING"
    send-notification "$PRITTY_DIR is not up to date" "$BODY" --urgency=critical --expire-time="$((2-SLEEP_DUR*1000))"

    # LOGGING Only when Notification was sent
    DATE="$(date -u +%Y-%m-%d-%H-%M-%S)"
    LOGPATH=~/logs/git_repo_check
    mkdir "$LOGPATH" --parents
    LOGFILE="$LOGPATH/$PRITTY_DIR-AT-$DATE.log"
    PWD="$(pwd)"
    touch "$LOGFILE"
    echo "PWD: $PWD" >> "$LOGFILE"
    echo "CLEAN DIR?: $CLEAN_DIR" >> "$LOGFILE"
    echo "BODY: $BODY" >> "$LOGFILE"
    echo "PATH (\$1): $1" >> "$LOGFILE"
    echo "Duration (\$2): $2" >> "$LOGFILE"

fi
