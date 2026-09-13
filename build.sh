#!/bin/bash

# Build the Expresso project from the repository root.
# The custom patch must be applied before running this script.

set -e

cmake -S Expresso -B build
cmake --build build -j"$(nproc)"

echo "Build completed successfully."
echo "Application: ./build/bin/Kafic"
echo "Tests:       ./build/bin/tests/tests"
