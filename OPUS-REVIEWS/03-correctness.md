# Cinnabar correctness review: pedagogical and technical alignment

*Reviewed 2026-06-19 by Claude Opus 4.8. I read a cross-section of koan, bridge, and
puzzle READMEs together with their solution READMEs and, where the claim turned on it, the
broken/starter source. I independently re-derived each technical claim from Mercury
semantics rather than taking the prior CODEX review's verdicts on trust — and on one
central point the prior review is itself mistaken.*

## Correctness: 7/10

The curriculum's normal standard is high: koans usually tie one compiler diagnostic to
one semantic cause, and the better solution notes explain a design trade-off rather than
just exhibit code. There is a real cluster of technical/contract errors to fix before
release — but it is **smaller than the prior review claimed**, because one of the six
flagged "errors" is correct as written, and another I read differently.

## Verified findings (with reasoning)

### 1. `solutions/2` "sorts and removes duplicates" — CORRECT as written; the prior review is wrong

`koans/determinism/02-nondet-in-det/solution/README.md:4,13` says `solutions/2` collects
results "into a sorted `list`" and "sorts them (removing duplicates)." The CODEX review
flagged this as a technical error, reasoning that `solutions/2` "is polymorphic and does
not require its result type to be orderable, so it cannot perform a general sort."

That reasoning rests on a false premise. Mercury has a **universal standard order of
terms**: the builtin `compare/3` is defined for *every* type via RTTI, and `list.sort`
uses it without any typeclass constraint. `solutions/2` is in fact documented to return
its results **in sorted order with duplicates removed** — which is exactly why the library
also provides `unsorted_solutions/2` for when you don't want that cost. So the cinnabar
explanation is accurate, and the prior review's correction would have introduced an error.
**No change needed here.** (If anything, the README could add a one-line pointer to
`unsorted_solutions/2` as the order-preserving counterpart.)

### 2. `nondet_koan.m` has two flaws, not one — CONFIRMED

`koans/determinism/02-nondet-in-det/nondet_koan.m`: `find_factor/2` binds an `int`
(`:10-13`), but `all_factors/2` passes its `list(int)` output variable straight into
`find_factor` (`:19`). That is a **type error** (`list(int)` vs `int`) on top of the
intended determinism error — and since Mercury type-checks before determinism-checks, the
learner sees the type error *first* and may never reach the lesson. This violates the
koan format's "one diagnostic" contract. Fix: thread a correctly-typed scalar
intermediate, or change the broken body to a scalar `Factor::out` so only the determinism
context is wrong.

### 3. Existential construction — genuine contradiction — CONFIRMED

`puzzles/advanced/06-plugin-architecture/solution/README.md:25-27` states that "the
packing of existentials is not available from regular clause heads in this version" and
shows `mk_upper = plugin(upper)` failing. But `koans/advanced/02-existential-escape/README.md:14,29`
teaches the exact construction syntax for this case: `'new tagged'(Label, Value)`. The
plugins example fails only because it used the *ordinary* constructor `plugin(upper)`
instead of `'new plugin'(upper)` — which is the koan's entire lesson. The two documents
contradict each other. The plugins note must either (a) use `'new plugin'(...)`, or
(b) identify the *specific additional restriction* (e.g. the `=> formatter(T)` constraint
interaction) that makes it fail even with `'new'`. As written it asserts a broad claim
the koan disproves.

### 4. Bridge 10 fan-in loses work — CONFIRMED

`bridge/10-parallel-pipeline/solution/README.md`: `dispatch` sends `no` to *both* worker
channels on end-of-stream (`:16-17`); each worker is the unchanged `transformer`, which
forwards `no` to the *shared* output channel. Two sentinels therefore arrive at the
output, but the unchanged `writer` exits at the **first** `no` — so it can stop while the
other worker still has buffered values. The note's claim "The total is still correct"
(`:34`) is not guaranteed. A correct fan-in needs the writer to count both worker
sentinels (or a merger that emits exactly one terminal sentinel after both finish). Task 4
compounds this: the supervisor only prints "would restart here" (`:142`) while the prose
admits full restart isn't implemented (`:150`) — a design sketch labeled as a solution.

### 5. Bridge 11 silently swallows read errors — CONFIRMED

`bridge/11-error-handling/solution/README.md`: `read_lines` maps `LineResult = error(_)`
to `Lines = []` (`:123-124`), discarding the `io.error`, after which `load_users` returns
`ok(Users)` (`:105`). This directly contradicts the solution's own decision table, which
chooses `io.res` precisely *to carry* the OS-level error (`:155-157,167`). A mid-read
failure becomes a successful, silently-truncated file. Fix: have `read_lines` return
`io.res(list(string))` and propagate the `error(Err)` case. This one matters extra because
the bridge's whole subject is choosing the right error contract — and the implementation
violates the contract it teaches.

### 6. Bidirectional-search determinism explanation — misleading — PARTIALLY AGREE

`puzzles/advanced/03-bidirectional-search/solution/README.md:36-43` claims that
`( gen(1,50,N0), has_property(N0,P) -> N = N0 ; fail )` is "inferred nondet" because
"`gen` is declared `nondet` and the mode checker propagates this upward before applying the
committed-choice reduction."

That contradicts Mercury's if-then-else semantics. **The condition of an if-then-else is a
single-solution (soft-cut) context**: a `nondet` condition commits to its first solution,
and the determinism of the whole construct is governed by the branches, not by the
condition's multiplicity. So `( <nondet> -> N = N0 ; fail )` should be **semidet**, not
nondet. The recursive `first_from` scan in the actual source (`bidir.m:75-82`) is a fine,
clear alternative — but it is **not required for the determinism reason the README gives**.
The explanation should either be corrected to Mercury's commit-on-condition rule, or state
the actual cause the author observed. (I reach the same "this is wrong" conclusion as
CODEX, but by a cleaner route — CODEX muddied it by invoking a `cc_*` effect "that cannot
be declared semidet," which isn't the mechanism.) Worth re-checking against `mmc` before
rewording, since determinism edge cases deserve a compiler confirmation.

### 7. Bridge 05 `(out,out) is nondet` explanation — imprecise — AGREE

`bridge/05-mode-reversal/solution/README.md:33-41` says an infinite relation has "no
finite way to enumerate it in Mercury" and that "a nondet mode is not the same logical
object" as the semidet/det modes. Both phrasings mislead. Infinite *nondeterministic
generation* is normal Mercury — each finite prefix is enumerable; it simply won't
terminate under `solutions/2`. And determinism is a property of a *calling mode*, not of
the logical relation, so a third mode computing the same relation with a different
determinism is not categorically "a different logical object." The real points are
(a) an unbounded generator needs a deliberate enumeration order, and (b)
`promise_equivalent_clauses` requires you to actually prove relation equivalence. Reword
toward those.

## Pedagogical alignment

Most exercises force their stated concept. `koans/determinism/05-promise-equivalent-solutions`
cannot be fixed honestly without engaging `cc_multi` vs `cc_nondet`;
`koans/concurrency/07-stm-context` has exactly one useful mismatch (IO state where STM
state is required); `bridge/04-determinism-ratchet` escalates committed choice →
`solutions/2`-before-`&` → semidet higher-order criterion, with notes that explain the
conjunction-level commitment rather than treating `->` as a magic fix.

The places a learner can sidestep the lesson:

- **Higher-order-inst koan vs its solution.** `koans/mode-system/03-higher-order-inst`
  advertises an inst-bearing wrapper, but (per CODEX, which I find plausible from the
  README) the solution converts `pred(int,int)` to `func(int)=int`, sidestepping the named
  predicate-inst lesson. Provide the inst-wrapper fix as the required path and the function
  conversion as an explicit alternative.
- **Puzzles that print the solution.** `puzzles/concurrent/02-pipeline` gives away all
  three stages in the prompt (see README review), so its "design" content is transcription.

## Solution quality

The strong notes explain *why* and surface trade-offs: bridge 01 distinguishes
validation-at-parse from validation-at-use; bridge 04 explains why `solutions/2` makes the
worker computations `det`-eligible for `&` and warns ordering changes; bridge 11's decision
table (`:163-177`) is a genuinely useful mechanism-choice framework — once the read-error
implementation is fixed to match it. The weaker notes prescribe an implementation without
its invariant (the `many`/`many_p` progress precondition — see the code-quality review) or
label a sketch as a solution (bridge 10 task 4).

## Release actions

1. Fix the four real defects: the existential contradiction (#3), bridge 10 fan-in (#4),
   bridge 11 read-error propagation (#5), and the bidirectional/bridge-05 determinism
   wordings (#6, #7).
2. Make `nondet_koan.m` single-flaw (#2).
3. **Do not "fix" the `solutions/2` note (#1)** — it is correct; the prior review's
   correction would introduce an error.
4. Add a per-koan review test: compile the broken program, assert the *first* diagnostic is
   the intended category, then compile the fixed version. (This is also what would have
   caught #2 mechanically.)
5. Add protocol tests for the concurrent exercises (exactly-once output, worker completion,
   error propagation) — "it compiles" is insufficient for channel-topology changes.
