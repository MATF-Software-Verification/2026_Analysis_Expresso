#!/bin/bash

# Run from the unit_tests/ directory.
# The custom patch must be applied before running this script.

set -e

cd ..

rm -rf build-coverage

cmake -S Expresso -B build-coverage -DCMAKE_BUILD_TYPE=Coverage
cmake --build build-coverage -j"$(nproc)" --target tests

# The test suite intentionally contains failing tests that document known bugs.
# Continue so that coverage is generated as well.
QT_QPA_PLATFORM=offscreen ./build-coverage/bin/tests/tests > unit_tests/catch2_test_output.txt 2>&1 || true

lcov --rc branch_coverage=1 \
    --capture \
    --directory build-coverage \
    --output-file unit_tests/coverage.info \
    --ignore-errors inconsistent,mismatch

lcov --rc branch_coverage=1 \
    --extract unit_tests/coverage.info "*/Expresso/src/*" \
    --output-file unit_tests/coverage.filtered.info 

lcov --rc branch_coverage=1 \
    --list unit_tests/coverage.filtered.info \
    > unit_tests/coverage_summary.txt

genhtml --rc branch_coverage=1 \
    --output-directory unit_tests/coverage_html \
    unit_tests/coverage.filtered.info

echo "Unit tests and coverage completed successfully."
echo "Results: unit_tests/"
echo "HTML report: unit_tests/coverage_html/index.html"
