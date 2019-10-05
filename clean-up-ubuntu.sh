#!/bin/bash

set -eu

BEFORE="$(du -sh / 2>/dev/null | cut -f1)"

#Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS

LANG=C snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done


# clean up packages
apt-get autoremove
apt-get autoclean

# purge logs
rm -rf /var/log/*

AFTER="$(du -sh / 2>/dev/null | cut -f1)"
echo "############################"
echo "## before=${BEFORE}"
echo "## after=${AFTER}"
