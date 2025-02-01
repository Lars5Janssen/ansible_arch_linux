#!/bin/bash
# TODO REFACTOR FUNCTION OUT
# MINWAIT=1
# MAXWAIT=300
# SLEEP_DUR=$((MINWAIT+RANDOM % (MAXWAIT-MINWAIT)))
# sleep $SLEEP_DUR
if [[ $3 != "no-wait" ]]; then
    min_wait=0
    max_wait=9
    sleep_dur=$((min_wait+RANDOM % (max_wait-min_wait)))
    sleep "$sleep_dur"m
fi

cd $1

BRANCH="$(git brach | awk '{ print $2 }')"
UNPUSHED_COMMITS="$(git log origin/$BRANCH..$BRANCH)"
UNPULLED_COMMITS="$(git log $BRANCH..origin/$BRANCH)"

send-notification ()
{
    XDG_RUNTIME_DIR=/run/user/$(id -u) notify-send "$1" "$2" $3 $4 
}

CLEAN_DIR="TRUE"

UNCOMITTED_STRING=""
if ! git status --porcelain | grep --quiet 'working tree clean' 
then
    UNCOMITTED_STRING="Uncommited changes\n"
    CLEAN_DIR="FALSE"
fi

UNPUSHED_STRING=""
if [[ $UNPUSHED_COMMITS != "" ]]; then
    UNPUSHED_STRING="Unpushed commits\n"
    CLEAN_DIR="FALSE"
fi

UNPULLED_STRING=""
if [[ $UNPULLED_COMMITS != "" ]]; then
    UNPULLED_STRING="New commits to pull\n"
    CLEAN_DIR="FALSE"
fi

BODY=""
if [[ "$CLEAN_DIR" == "FALSE" ]]; then
    PRITTY_DIR="$(pwd | sed 's:/: :g' | awk '{ print $NF }')"
    BODY="$UNCOMITTED_STRING $UNPUSHED_STRING $UNPULLED_STRING"
    send-notification "$PRITTY_DIR is not up to date" "$BODY" --expire-time="$2"

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
