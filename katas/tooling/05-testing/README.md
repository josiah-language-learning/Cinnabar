# Kata: testing in Mercury

Mercury has no built-in test framework. The convention is: test predicates succeed silently and call `error/1` on failure.

Three standard-library tools carry most of the weight:

- `require` — `error(Msg)` for unconditional abort; build assertions from it
- `exception` — `try(Goal, Result)` to run a goal and catch whatever it throws
- `solutions` — `solutions(Goal, Sols)` to verify a nondet predicate produces exactly the right answer set

## The assertion pattern

Because Mercury has no polymorphic `show`, your error messages cannot automatically include mismatched values. Accept this as a correct design choice: the `Context` string should describe what is being tested, which is more useful than a raw value dump.

```mercury
:- pred check(string::in, pred::in(pred is semidet)) is det.
check(_, Goal) :- call(Goal).
check(Context, Goal) :- not call(Goal), error("FAIL: " ++ Context).
```

## Steps

### 1. Write `check/2`

Implement the pattern above. Succeed silently if the goal succeeds; call `error/1` if it fails.

### 2. Write `check_equal/3`

```mercury
:- pred check_equal(T::in, T::in, string::in) is det.
```

Calls `error(Context)` if the two values are not `=/2` equal.

### 3. Write `check_solutions/3`

```mercury
:- pred check_solutions(pred(T)::in(pred(out) is nondet),
                        list(T)::in, string::in) is det.
```

Use `solutions/2` to collect all solutions, sort both lists with `list.sort/2`, then call `check_equal`.

### 4. Write a test suite

Define a small predicate with known correct behaviour, for example:

```mercury
:- pred sign(int::in, string::out) is det.
sign(N, "positive") :- N > 0.
sign(0, "zero").
sign(N, "negative") :- N < 0.
```

Write `run_tests(!IO)` that calls `check` and `check_equal` for several cases, then prints `"All tests passed.\n"` at the end.

### 5. (Advanced) Test a predicate that should throw

`exception.try/2` has mode `(pred(out) is det, out) is cc_multi`. The `cc_multi` means
Mercury commits to one resolution. To use it in a `det` context:

```mercury
promise_equivalent_solutions [Result] (
    try(Goal, Result)
),
```

Write `check_throws(Goal, Context)` that uses this pattern. Succeed if `Result = exception(_)`, call `error(Context)` if the goal completed normally.

## Getting started

```mercury
:- module testing_kata.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module exception.
:- import_module list.
:- import_module require.
:- import_module solutions.
:- import_module string.

main(!IO) :- true.
```
