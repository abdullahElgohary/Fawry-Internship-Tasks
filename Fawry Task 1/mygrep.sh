#!/bin/bash

SCRIPT_NAME=$(basename "$0")

show_help() {
    echo "Usage: $SCRIPT_NAME [-n -v] PATTERN FILE" >&2
    echo "Options:" >&2
    echo "  -n  Show line numbers" >&2
    echo "  -v  Invert matches" >&2
    exit 1
}

SHOW_LINES="no"
INVERT="no"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            show_help
            ;;
        -*)
            options="${1#-}"
            for (( i=0; i<${#options}; i++ )); do
                case "${options:$i:1}" in
                    n) SHOW_LINES="yes" ;;
                    v) INVERT="yes" ;;
                    *) echo "Unknown option: -${options:$i:1}" >&2; show_help ;;
                esac
            done
            shift
            ;;
        *)
            break
            ;;
    esac
done

if [ $# -ne 2 ]; then
    echo "Need both pattern and filename" >&2
    show_help
fi

PATTERN=$1
FILENAME=$2

[ -f "$FILENAME" ] || { echo "File does not exist: $FILENAME" >&2; exit 2; }

# Modified line to add case-insensitive search (-i)
GREP_CMD="grep -i"
[ "$INVERT" = "yes" ] && GREP_CMD+=" -v"
[ "$SHOW_LINES" = "yes" ] && GREP_CMD+=" -n"

$GREP_CMD "$PATTERN" "$FILENAME"