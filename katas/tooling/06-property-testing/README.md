# Kata: property-based testing

Mercury has no QuickCheck library for version 22.01.8. This kata teaches the idiomatic
Mercury alternative: build property tests directly from `solutions/2` and a generator
predicate. The pattern requires no framework and no external dependencies. You can copy it
into any Mercury project.

---

## The three components

```
generator (nondet pred) ──► runner ──► property (semidet pred)
                              │
                              └── reports: PASS N cases | FAIL counterexample = X
```

**Generator** — a `nondet` predicate that enumerates a *bounded* set of test inputs.
Bounded matters: `solutions/2` collects all solutions into a list, so an unbounded generator
(like a recursive list builder with no depth limit) will loop forever.

**Property** — a `semidet` predicate that succeeds when the invariant holds and *fails*
when it does not. The failure is how a counterexample is signaled. Never declare a property
`det` — a `det` predicate can never fail, which means counterexamples are silently swallowed.

**Runner** — calls `solutions(Gen, Cases)` to enumerate all test inputs, then checks the
property against each one. Reports the first counterexample if any case fails.

---

## The runner (provided)

The runner uses higher-order mode annotations — syntax that can be unfamiliar. It is
provided for you. Read it once, understand what each type/mode says, then focus on writing
generators and properties.

```mercury
:- pred check_property(string::in,
    pred(T)::in(pred(out) is nondet),
    pred(T)::in(pred(in) is semidet),
    io::di, io::uo) is det.
```

- `pred(out) is nondet` — a closure that generates values; Mercury will call it via
  `solutions/2`, which backtracks until all solutions are found
- `pred(in) is semidet` — a closure that checks one value; succeeds = holds, fails =
  counterexample

`find_counterexample` walks the case list and returns `yes(X)` for the first `X` where
the property fails.

---

## Steps

### 1. Write `gen_small_int`

Generate integers from -10 to 10.

```mercury
:- pred gen_small_int(int::out) is nondet.
```

Use `int.nondet_int_in_range/3` — Mercury 22's bounded integer generator (note: `int.between` does not exist in Mercury 22). This produces 21 cases.

### 2. Write `gen_nat`

Generate natural numbers from 0 to 20.

### 3. Write `gen_tiny_int` and `gen_small_list`

`gen_tiny_int` generates integers from -3 to 3 (7 values). Use it as the element
generator inside `gen_small_list`, which generates all lists of length 0–3. This gives
1 + 7 + 49 + 343 = 400 cases.

```mercury
:- pred gen_list_aux(int::in, list(int)::out) is nondet.
gen_list_aux(0, []).
gen_list_aux(Len, [H | T]) :-
    Len > 0,
    gen_tiny_int(H),
    gen_list_aux(Len - 1, T).

:- pred gen_small_list(list(int)::out) is nondet.
gen_small_list(Xs) :-
    int.nondet_int_in_range(0, 3, Len),
    gen_list_aux(Len, Xs).
```

Write this pattern. Notice how the bounded depth terminates the recursion.

### 4. Write `prop_abs_nonneg`

`int.abs(N) >= 0` for any integer N. This should always pass.

### 5. Write `prop_double_add`

`N * 2 = N + N` for any integer N. Always passes.

### 6. Write `prop_positive`

`N > 0`. This fails for N = 0 and negatives. Run it against `gen_small_int` and observe
the counterexample output. The first counterexample found is -10 (smallest in the
generated order).

### 7. Write `prop_reverse_length`

For any `list(int)` Xs: `list.length(list.reverse(Xs)) = list.length(Xs)`. Always passes.

### 8. Write `prop_no_duplicates`

A list has no duplicate elements if no element appears more than once.

```mercury
prop_no_duplicates([]).
prop_no_duplicates([H | T]) :-
    not list.member(H, T),
    prop_no_duplicates(T).
```

Run against `gen_small_list`. This should find a counterexample: a list like `[-3, -3]`
where the element range makes duplicates likely.

### 9. Connect everything in `main`

```mercury
main(!IO) :-
    check_property("prop_abs_nonneg",    gen_small_int,  prop_abs_nonneg,    !IO),
    check_property("prop_double_add",    gen_small_int,  prop_double_add,    !IO),
    check_property("prop_positive",      gen_small_int,  prop_positive,      !IO),
    check_property("prop_reverse_length", gen_small_list, prop_reverse_length, !IO),
    check_property("prop_no_duplicates", gen_small_list,  prop_no_duplicates, !IO).
```

Expected output:
```
PASS prop_abs_nonneg (21 cases)
PASS prop_double_add (21 cases)
FAIL prop_positive: counterexample = -10
PASS prop_reverse_length (400 cases)
FAIL prop_no_duplicates: counterexample = [-3, -3]
```

---

## Taking this further

- **Compose generators**: write `gen_int_pair` that produces every pair from two
  `gen_small_int` calls. Use it to test commutativity: `A + B = B + A` for all pairs.

- **Shrinking**: QuickCheck frameworks shrink failing inputs to the smallest counterexample.
  This runner reports the first counterexample in generation order. You can get
  smallest-first shrinking for free by ordering your generator so smaller/simpler values
  come first — which `int.nondet_int_in_range(-10, 10, N)` already does.

- **Controlling case counts**: reduce the generator range or depth limit if a particular
  property takes too long. `solutions/2` fully enumerates before checking, so generator
  size directly controls runtime.

- **Custom types**: write a generator for your own discriminated union type using
  `member(X, [constructor1, constructor2, ...])`. Property testing is not limited to
  integers and lists.
