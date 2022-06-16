#!/usr/bin/env bash
set -ex

START_COMMAND="chromium-browser"
MAXIMIZE="true"
DEFAULT_ARGS=""

if [[ $MAXIMIZE == 'true' ]] ; then
    DEFAULT_ARGS+=" --start-maximized"
fi

ARGS=${APP_ARGS:-$DEFAULT_ARGS}

$START_COMMAND $ARGS