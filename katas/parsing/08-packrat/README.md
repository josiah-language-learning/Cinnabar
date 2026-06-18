# 08 — Packrat parsing via tabling

**Concept:** memoizing DCG rules with `pragma memo` to prevent re-parsing common prefixes;
the packrat parsing algorithm; why tabling is incompatible with the parallel grade

**Not in the Mercury tutorial.**

---

## The re-parsing problem

Standard DCG rules backtrack. A grammar with common prefixes re-parses those prefixes
on each alternative:

```
s --> a, b, [c]
s --> a, b, [d]
```

Both alternatives of `s` call `a` and `b` from scratch. For a long common prefix, this
gives quadratic or worse parse time.

---

## Packrat: memoize per position

Adding `pragma memo` to a DCG rule memoizes it: the rule is evaluated at most once per
input position. Each subsequent call with the same position returns the cached result:

```mercury
:- pred a_tabled(list(token)::in, list(token)::out) is det.
:- pragma memo(a_tabled/2).
a_tabled --> ( [x] -> a_tabled ; [] ).
```

The two hidden DCG list arguments serve as the "position" key for memoization. This turns
the parser into a packrat parser with O(n) worst-case time.

---

## Tabling and the parallel grade

`pragma memo` is **not compatible with the parallel grade** (`asm_fast.par.gc.stseg`).
The Mercury compiler will emit a warning and silently ignore the pragma in that grade:

```
Ignoring the `:- pragma memo' declaration ... because tabling is not
compatible with parallel execution.
```

To use actual memoization, compile with the base grade:
```bash
mmc --make --grade asm_fast.gc.stseg start
```

The kata compiles (and tests the *correctness* of the grammar) in any grade. The
performance benefit of memoization only applies in non-parallel grades.

---

## If-then-else is required for `det` DCG rules

Multiple DCG clauses always infer `multi` or `nondet`. To get a `det` rule, use
if-then-else to commit to one branch:

```mercury
% nondet — two clauses:
a --> [x], a.
a --> [].

% det — if-then-else:
a --> ( [x] -> a ; [] ).
```

The if-then-else version commits to consuming `x` when `x` is present, and to epsilon
otherwise. No backtracking, no ambiguity.

---

## The test grammar

```
s --> a, b, ( [c] → [] | [d] )
a --> ( [x] → a | [] )    -- consumes x*
b --> ( [y] → b | [] )    -- consumes y*
```

Input `[x, x, x, y, y, c]`: `a` consumes three `x`s, `b` consumes two `y`s, `[c]`
closes the parse. Both `s_naive` (no tabling) and `s_tabled` (with tabling) produce the
same correct result; the difference is only performance.

---

## What you will build

### `s_naive`, `a_naive`, `b_naive`

Implement the grammar without tabling. Verify it parses correctly.

### `s_tabled`, `a_tabled`, `b_tabled`

Add `pragma memo` to `a_tabled` and `b_tabled`. Verify the same correctness.

### Timing comparison (optional)

Compile with `asm_fast.gc.stseg` (non-parallel) to enable actual memoization. Then time
both parsers on a large input (e.g., 1000 x's + 1000 y's + c):
```bash
mmc --make --grade asm_fast.gc.stseg start && time ./start
```

---

## Checkpoint

- Both `s_naive` and `s_tabled` parse `xxxyyc` and `xxyyd` correctly
- Both reject inputs with neither `c` nor `d` at the end
- You can state: what does `pragma memo` do to a DCG rule?
- You can state: why is tabling incompatible with the parallel grade?
