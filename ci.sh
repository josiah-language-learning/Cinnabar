#!/usr/bin/env bash
# CI gate for cinnabar.
#
# Rules:
#   - *_koan.m files in koans/ (not in solution/) must FAIL to compile.
#   - solution/*.m files in koans/ must PASS compilation.
#   - katas/*/start.m files must PASS compilation.
#   - bridge starter *.m files (not in solution/) must PASS compilation.
#   - puzzles/*/solution/*.m files must PASS compilation.
#
# Text-only koans (no *_koan.m file) are skipped automatically.

set -uo pipefail

CINNABAR="$(cd "$(dirname "$0")" && pwd)"
GRADE="asm_fast.par.gc.stseg"

if ! command -v mmc > /dev/null 2>&1; then
    echo "mmc not found on PATH. Run inside a nix dev shell: nix develop --command ./ci.sh"
    exit 1
fi

pass=0
fail=0
failures=()

# Silence mmc output unless verbose mode is set.
MMC_OUT=/dev/null
if [[ "${VERBOSE:-}" == "1" ]]; then
    MMC_OUT=/dev/stdout
fi

compile_fail() {
    local dir="$1"
    local module="$2"
    local label="$3"
    (
        cd "$dir"
        rm -rf Mercury/
        mmc --make --grade "$GRADE" "$module" > "$MMC_OUT" 2>&1
    )
    local code=$?
    if [[ $code -ne 0 ]]; then
        echo "  PASS (broke as expected): $label"
        ((pass++))
    else
        echo "  FAIL (koan compiled — it should not): $label"
        ((fail++))
        failures+=("koan compiled when it should fail: $label")
    fi
}

compile_pass() {
    local dir="$1"
    local module="$2"
    local label="$3"
    (
        cd "$dir"
        rm -rf Mercury/
        mmc --make --grade "$GRADE" "$module" > "$MMC_OUT" 2>&1
    )
    local code=$?
    if [[ $code -eq 0 ]]; then
        echo "  PASS: $label"
        ((pass++))
    else
        echo "  FAIL: $label"
        ((fail++))
        failures+=("failed to compile: $label")
    fi
}

module_of() {
    # Strip path and .m extension to get the module name.
    basename "$1" .m
}

# ---------------------------------------------------------------------------
# 1. Koans — must fail
# ---------------------------------------------------------------------------
echo "=== Koans (expect compile failure) ==="
while IFS= read -r -d '' koan_file; do
    dir="$(dirname "$koan_file")"
    module="$(module_of "$koan_file")"
    label="${koan_file#"$CINNABAR/"}"
    compile_fail "$dir" "$module" "$label"
done < <(
    find "$CINNABAR/koans" -name "*_koan.m" \
        ! -path "*/solution/*" \
        -print0 | sort -z
)

# ---------------------------------------------------------------------------
# 2. Koan solutions — must pass
# ---------------------------------------------------------------------------
echo ""
echo "=== Koan solutions (expect compile success) ==="
while IFS= read -r -d '' sol_file; do
    dir="$(dirname "$sol_file")"
    module="$(module_of "$sol_file")"
    label="${sol_file#"$CINNABAR/"}"
    compile_pass "$dir" "$module" "$label"
done < <(
    find "$CINNABAR/koans" -path "*/solution/*.m" \
        ! -name "*.mh" \
        -print0 | sort -z
)

# ---------------------------------------------------------------------------
# 3. Kata starters — must pass
# ---------------------------------------------------------------------------
echo ""
echo "=== Kata starters (expect compile success) ==="
while IFS= read -r -d '' start_file; do
    dir="$(dirname "$start_file")"
    module="$(module_of "$start_file")"
    label="${start_file#"$CINNABAR/"}"
    compile_pass "$dir" "$module" "$label"
done < <(
    find "$CINNABAR/katas" -name "start.m" \
        ! -path "*/solution/*" \
        -print0 | sort -z
)

# ---------------------------------------------------------------------------
# 4. Bridge starters — must pass
# ---------------------------------------------------------------------------
echo ""
echo "=== Bridge starters (expect compile success) ==="
while IFS= read -r -d '' bridge_file; do
    dir="$(dirname "$bridge_file")"
    module="$(module_of "$bridge_file")"
    label="${bridge_file#"$CINNABAR/"}"
    compile_pass "$dir" "$module" "$label"
done < <(
    find "$CINNABAR/bridge" -name "*.m" \
        ! -path "*/solution/*" \
        ! -name "*.mh" \
        -print0 | sort -z
)

# ---------------------------------------------------------------------------
# 5. Puzzle solutions — must pass
# ---------------------------------------------------------------------------
echo ""
echo "=== Puzzle solutions (expect compile success) ==="
while IFS= read -r -d '' puzzle_file; do
    dir="$(dirname "$puzzle_file")"
    module="$(module_of "$puzzle_file")"
    label="${puzzle_file#"$CINNABAR/"}"
    compile_pass "$dir" "$module" "$label"
done < <(
    find "$CINNABAR/puzzles" -path "*/solution/*.m" \
        ! -name "*.mh" \
        -print0 | sort -z
)

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "=== Results ==="
echo "  Passed: $pass"
echo "  Failed: $fail"
if [[ ${#failures[@]} -gt 0 ]]; then
    echo ""
    echo "Failures:"
    for f in "${failures[@]}"; do
        echo "  - $f"
    done
    echo ""
    exit 1
fi
echo ""
echo "All checks passed."
