#!/bin/bash

# Run from the clang-tidy/ directory.
# The project must be built before running this script.

set -e

command -v run-clang-tidy-21 >/dev/null || {
    echo "run-clang-tidy-21 is not installed."
    exit 1
}

BUILD_DIR="../build"
REPORT_FILE="clang_tidy_report.txt"
CHECKS='clang-diagnostic-*,clang-analyzer-*,modernize-*,performance-*,readability-*,bugprone-*'

echo "Running clang-tidy..."

run-clang-tidy-21 \
    -p "$BUILD_DIR" \
    -checks="$CHECKS" \
    'Expresso/src/.*\.cpp$' \
    > "$REPORT_FILE" 2>&1

echo "Clang-tidy analysis completed."
echo "Report: $REPORT_FILE"
