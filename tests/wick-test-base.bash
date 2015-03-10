#!/bin/bash
set -e

# Used to set TEST_DIR
#
# Outputs the directory of this file without "..".
find-script-dir() {
    cd "$1"
    echo "$PWD"
}

# Simulates a command's presence by using a fixture
#
# Arguments are appended to the command with underscores, so a simulated
# `ifconfig -v tun0` will become `ifconfig_-v_tun0`.
#
# Usage:
#     $1: Command name
#     $2: Fixture directory
mock-command() {
    eval "$1() { mock-command-internals '$2/$1' \"\$@\"; }"
}

# This is the guts of a mocked command
#
# Builds a filename from the parameters and executes it.
#
# Usage:
#     $1: Initial directory and file to use
#     $2-$*: Arguments passed to the command
mock-command-internals() {
    local ARG FILE

    FILE="$1"
    shift

    for ARG in "$@"; do
        FILE="${FILE}_$ARG"
    done

    "$FILE"
}

TEST_DIR=$(find-script-dir "$PWD/${1%/*}")
WICK_DIR=${TEST_DIR%/*}
