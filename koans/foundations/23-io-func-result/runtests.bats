#!/usr/bin/env bats

KOAN="$(cd "$(dirname "${BATS_TEST_FILENAME}")" && pwd)"
GRADE="asm_fast.par.gc.stseg"

setup() {
    rm -rf "$KOAN/Mercury/" "$KOAN/solution/Mercury/"
}

@test "func_result_koan.m fails with expected !IO function-result errors" {
    cd "$KOAN"
    run mmc --make --grade "$GRADE" func_result_koan
    [ "$status" -ne 0 ]
    [[ "$output" == *"no clauses for function \`hello'/1"* ]]
    [[ "$output" == *"clause for function \`hello'/2"* ]]
    [[ "$output" == *"without corresponding"* ]]
    [[ "$output" == *"!IO cannot be a function result"* ]]
    [[ "$output" == *"You probably meant !:IO"* ]]
    [[ "$output" == *"no clauses for function \`hello'/2"* ]]
    [[ "$output" == *"Error making"* ]]
}

@test "solution/fixed.m compiles and produces correct output" {
    cd "$KOAN/solution"
    run mmc --make --grade "$GRADE" fixed
    [ "$status" -eq 0 ]
    run ./fixed
    [ "$output" = "Hello!
Hi!" ]
}
