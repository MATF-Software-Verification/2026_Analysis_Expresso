#!/bin/bash

# Run from the valgrind/ directory.
# The project must be built before running this script.
# The GUI scenario is performed manually.

set -e

command -v valgrind >/dev/null || {
    echo "valgrind is not installed."
    exit 1
}

TESTS="../build/bin/tests/tests"
REPORT_FILE="tests_memcheck_report.txt"

if [ ! -f "$TESTS" ]; then
    echo "Error: $TESTS does not exist. Run build.sh first."
    exit 1
fi

echo "Running Valgrind on the test binary..."

QT_QPA_PLATFORM=offscreen valgrind \
    --leak-check=full \
    --show-leak-kinds=definite \
    --track-origins=yes \
    --log-file="$REPORT_FILE" \
    "$TESTS" || true

echo "Valgrind analysis completed."
echo "Report: $REPORT_FILE"
echo ""
echo "GUI analysis must be run manually:"
echo "valgrind --leak-check=full --show-leak-kinds=definite --track-origins=yes --log-file=kafic_memcheck.txt ../build/bin/Kafic"