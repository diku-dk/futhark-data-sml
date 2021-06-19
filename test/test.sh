#!/bin/sh

set -e
mlkit test.mlb

dotest() {
    s=$1
    echo "Test: $1"
    futhark dataset -b -g "$s" > infile
    ./run infile outfile
    if ! cmp infile outfile; then
        echo "Mismatch"
        exit 1
    fi
}

dotest "[1][2][3]u8"
dotest "[1][2][3]u16"
dotest "[1][2][3]u32"
dotest "[1][2][3]u64"
dotest "[1][2][3]i8"
dotest "[1][2][3]i16"
dotest "[1][2][3]i32"
dotest "[1][2][3]i64"
dotest "[1][2][3]f32"
dotest "[1][2][3]f64"
dotest "[1][2][3]bool"
dotest "bool"

mlkit test_convert.mlb
./run
