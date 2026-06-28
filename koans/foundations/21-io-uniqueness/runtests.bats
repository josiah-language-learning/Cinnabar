#!/usr/bin/env bats

KOAN="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
GRADE="asm_fast.gc.stseg"

setup() {
    rm -rf "$KOAN/Mercury/" "$KOAN/solution/Mercury/"
}

@test "io_uniqueness_koan.m fails with unique-mode error on IO0" {
    cd "$KOAN"
    run mmc --make --grade "$GRADE" io_uniqueness_koan
    [ "$status" -ne 0 ]
    [[ "$output" == *"In clause for"* ]]
    [[ "$output" == *"in argument 2 of call to predicate"* ]]
    [[ "$output" == *"io.write_string"* ]]
    [[ "$output" == *"unique-mode error"* ]]
    [[ "$output" == *"clobber its argument"* ]]
    [[ "$output" == *"IO0' is still"* ]]
    [[ "$output" == *"live."* ]]
    [[ "$output" == *"Error making"* ]]
}

@test "solution/fixed.m compiles and produces correct output" {
    cd "$KOAN/solution"
    run mmc --make --grade "$GRADE" fixed
    [ "$status" -eq 0 ]
    run ./fixed
    [ "$output" = "Hello, world!
Hello, Mercury!
The world of Mercury says hello!" ]
}
