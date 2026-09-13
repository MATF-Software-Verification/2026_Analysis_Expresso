#!/bin/bash

# Run from the fuzzing/ directory.
# Clang must be installed before running this script.

set -e

command -v clang++-21 >/dev/null || {
    echo "clang++-21 is not installed."
    exit 1
}

BUILD_DIR="../build-fuzz"
CORPUS_DIR="corpus"
LOAD_CORPUS_DIR="corpus_load"

echo "Building fuzzing harnesses..."

rm -rf "$BUILD_DIR"

cmake -S . -B "$BUILD_DIR" -DCMAKE_CXX_COMPILER=clang++-21
cmake --build "$BUILD_DIR" -j"$(nproc)"

if [ ! -f "$BUILD_DIR/fuzz_fromvariant" ] || [ ! -f "$BUILD_DIR/fuzz_load" ]; then
    echo "Error: fuzzing harnesses were not built."
    exit 1
fi

echo "Running fuzz_fromvariant..."

mkdir -p "$CORPUS_DIR"
QT_QPA_PLATFORM=offscreen "$BUILD_DIR/fuzz_fromvariant" \
    -max_total_time=300 \
    -artifact_prefix=./ \
    "$CORPUS_DIR"

echo "Running fuzz_load..."

mkdir -p "$LOAD_CORPUS_DIR"
ASAN_OPTIONS=detect_leaks=0 "$BUILD_DIR/fuzz_load" \
    -max_total_time=300 \
    -artifact_prefix=./ \
    "$LOAD_CORPUS_DIR"

echo "Fuzzing completed."
echo "Check fuzzing/ for crash and leak artifacts."