#!/usr/bin/env bats

CINNABAR="$(cd "$(dirname "${BATS_TEST_FILENAME:-$0}")" && pwd)"
GRADE="asm_fast.par.gc.stseg"
KATA="$CINNABAR/katas/foundations/00-reactivation/01-hello-world"

setup() {
    rm -rf "$KATA/Mercury"
}

# ---------------------------------------------------------------------
# 01-hello-world
# ---------------------------------------------------------------------
@test "01-hello-world: start.m compiles" {
    cd "$KATA"
    run mmc --make --grade "$GRADE" start
    [ "$status" -eq 0 ]
}

@test "01-hello-world: start.m (noop) produces no output" {
    cd "$KATA"
    run ./start
    [ "$output" = "" ]
}

# ---------------------------------------------------------------------
# 21-io-uniqueness
# ---------------------------------------------------------------------
KOAN_21="$CINNABAR/koans/foundations/21-io-uniqueness"

@test "21-io-uniqueness: runtests.bats proves koan compilation fails correctly" {
    cd "$KOAN_21"
    run ./runtests.bats
    [ "$status" -eq 0 ]
}
