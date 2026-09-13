#!/bin/bash

# Run from the heaptrack/ directory.
# The application must be built before running this script.
# Scenario: Design table arrangement -> enter name/number of tables -> Add Table x3 -> Save -> Quit.

set -e

command -v heaptrack >/dev/null || {
    echo "heaptrack is not installed."
    exit 1
}

command -v heaptrack_print >/dev/null || {
    echo "heaptrack_print is not installed."
    exit 1
}

REPORT_FILE="kafic_heaptrack"
TEXT_REPORT="${REPORT_FILE}_report.txt"

echo "Running Heaptrack..."
echo "Complete the test scenario in Kafic and close the application."

heaptrack -o "$REPORT_FILE" ../build/bin/Kafic

heaptrack_print --print-leaks \
    -f "${REPORT_FILE}.gz" \
    > "$TEXT_REPORT"

echo "Heaptrack analysis completed."
echo "Data: ${REPORT_FILE}.gz"
echo "Text report: $TEXT_REPORT"
echo "GUI report: heaptrack_gui ${REPORT_FILE}.gz"