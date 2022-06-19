#!/usr/bin/env bash
set -ex
START_COMMAND="code"

export MAXIMIZE="true"
export MAXIMIZE_NAME="Visual Studio Code"
MAXIMIZE_SCRIPT=$STARTUPDIR/maximize_window.sh
DEFAULT_ARGS="--no-sandbox"
ARGS=${APP_ARGS:-$DEFAULT_ARGS}

bash ${MAXIMIZE_SCRIPT} &
$START_COMMAND $ARGS $OPT_URL