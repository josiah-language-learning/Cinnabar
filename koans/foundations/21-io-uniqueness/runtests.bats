#!/usr/bin/env bats

GRADE="asm_fast.par.gc.stseg"

setup() {
    cd "$(dirname "${BATS_TEST_FILENAME}")"
    rm -rf Mercury/
}

@test "io_uniqueness_koan.m fails with unique-mode error on IO0" {
    run mmc --make --grade "$GRADE" io_uniqueness_koan
    [ "$status" -ne 0 ]
    [[ "$output" == *"unique-mode error"* ]]
    [[ "$output" == *"IO0"* ]]
}
