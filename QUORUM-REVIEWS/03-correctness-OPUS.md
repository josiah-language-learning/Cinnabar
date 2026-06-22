# Review 03 — Correctness

**Reviewer:** OPUS (Claude Opus 4.8)
**Date:** 2026-06-22
**Method:** This is the dimension where I diverge most from the other reviewers, because
**I actually ran `mmc` 22.01.8** in the nix dev shell (entered through the prebuilt
committed rev; `XDG_CACHE_HOME` redirected). BIG-PICKLE and DEEPSEEK both state they
cannot compile and reason statically. Several of their correctness claims are therefore
unverified or, in one case, fabricated.

## Verified GOOD

### The koan mechanism is robust — no false-passing koans
I compiled the koans the gate flagged as "diagnostic mismatch." **All still fail to
compile** (exit ≠ 0) — none silently started passing, which would be the only severe koan
bug. Moreover, the *primary* diagnostic line matches the `.err` snapshot in every case I
checked:

| koan | actual first error | snapshot first error |
|---|---|---|
| `foundations/01-maybe` | `type error in unification of variable 'MaybeDoubled'` | identical |
| `type-system/01-adt` | `undefined symbol '[\|]'/2` | identical |
| `mode-system/03-higher-order-inst` | `undefined symbol '*'/2` | identical |
| `foundations/06-file-io` | `ambiguous overloading causes type ambiguity` | identical |

So the eight "diagnostic mismatch" failures are **low severity**: the koans break exactly
as intended and the headline error is correct; only a *secondary* line (a follow-on
context phrase) drifted from the snapshot. This is snapshot fragility (Laguna's old
finding), not pedagogical breakage. Fix by regenerating the eight `.err` files from live
`mmc` output — a `[User]`/dev-shell task.

### Solutions compile
Full-gate run earlier this session: **303 pass / 8 fail**, the 8 being exactly the koan
snapshot drifts above. Every kata starter, koan solution, bridge starter, and puzzle
solution compiles. I additionally spot-recompiled `puzzles/advanced/04-combinator-library/
solution/combinators.m` (DEEPSEEK's code-quality target) — it **compiles**; its issues are
quality, not correctness.

### `combinators.m:28` `:- fail` is CORRECT — the synthesis "fix" would break it
The 06-21 consensus (`§1.6`, all four prior models) said to replace `empty(_,_,_) :- fail.`
with an empty fact body under `is failure`. I mmc-verified this earlier in the session:
**the empty body does NOT compile** under `:- mode empty(out,in,out) is failure` — it
produces `mode error: argument 2 did not get sufficiently instantiated`. The `:- fail.`
body is required. All four prior reviewers were wrong about Mercury here; the kept
`:- fail.` (plus the COMPILER-LESSONS note) is right.

## Real bugs found (that the other reviewers MISSED)

### 1. Bridge 04 taught non-compiling `det` code (FOUND + FIXED this session)
The bridge-04 solution notes claimed an if-then-else "commits to the first solution" of a
`nondet` goal, yielding `det`. **Compiler-verified false** (5 independent tests): when the
condition's witness escapes into the then-branch, the construct stays `multi` and
`first_coloring`/`first_where` do **not** compile (`a function's primary mode cannot be
multi`). The §6 snippet gate could never catch this — it does syntax/declaration checks
only, not determinism. I rewrote both to genuinely-`det` `solutions`+head /
`find_first_match` / `cc_multi` forms and verified them. **No prior review caught this**,
precisely because none compiled the snippets.

### 2. The `ci.sh §6` snippet gate was itself broken (FOUND + FIXED this session)
It invoked `mmc --make --errorcheck-only`, which 22.01.8 rejects as a conflicting
combination — so **all 40 bridge snippet blocks failed spuriously**, plus a trailing-dot
bug in import extraction emitted `import_module …, map..`. Fixed to `--make-short-interface`
+ dot-strip; snippets now 40/40. DEEPSEEK noticed bridge-12 snippet failures but
attributed them to a missing `float` import (one symptom); the root cause was the invalid
flag combination affecting every bridge.

## Real CURRENT problem the reviewers under-weighted

### `ci.sh` is gone from the working tree
`git status` shows `D ci.sh` with an untracked `ci-bak.sh` in its place; `Agents.md` still
calls `ci.sh` three times and the committed tree (HEAD) still has `ci.sh`. **As the
working tree stands, `nix develop … --command ./ci.sh` fails — there is no `ci.sh`.** The
documented quality gate is currently unrunnable. DEEPSEEK saw the rename and called it
"confusing"; it is more than that — it is the gate disappearing. Restore `ci.sh` (or
update `Agents.md` + the rev workflow consistently).

## Caveats I could NOT fully clear
- §6 verifies snippet *syntax*, not *determinism/types* (they're fragments). The bridge-04
  bug shows this is a real blind spot; a determinism audit of all solution-README snippets
  (compile each as a self-contained module with stub types) is worthwhile future work.

## Score: **7.5/10**
The compiled curriculum is correct and the koan mechanism is sound. I dock from an 8 for
the **current working-tree state** (missing `ci.sh`) and for the snippet gate's
determinism blind spot that hid a real bug — both fixable, but both real *today*.
