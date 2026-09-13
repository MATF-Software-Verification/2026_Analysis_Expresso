#!/bin/bash

# Run from the clazy/ directory.
# The project must be built before running this script.

set -e

command -v clazy-standalone >/dev/null || {
    echo "clazy-standalone is not installed."
    exit 1
}

REPORT_FILE="clazy_report.txt"

echo "Running Clazy..."

clazy-standalone \
    -p ../build \
    --checks=level0,level1,level2 \
    ../Expresso/src/*.cpp \
    > "$REPORT_FILE" 2>&1

echo "Clazy analysis completed."
echo "Report: $REPORT_FILE"

grep -oE '\[-Wclazy-[a-zA-Z0-9-]+\]' "$REPORT_FILE" \
    | sort \
    | uniq -c \
    | sort -rn