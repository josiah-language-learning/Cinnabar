# 02 — Multi-mode predicates

**Concept:** multiple `:- mode` declarations, `pragma promise_equivalent_clauses`,
mode-specific clause selection

**Tutorial cross-reference:** Mercury Tutorial §4 shows single-mode predicates. Multi-mode
with separate clause sets is not covered.

---

## What you will build

`my_length/2` and `my_append/3`, both with multiple mode declarations.

---

## `my_length` with two modes

```mercury
:- pred my_length(list(T), int).
:- mode my_length(in, out) is det.
:- mode my_length(out, in) is multi.
```

The first mode: given a list, compute its length. The second mode: given a length N,
generate all lists of that length (nondeterministically — there are infinitely many lists,
but for a fixed element type, the structure is determined).

For the `(out, in)` mode to terminate and be useful, it needs to generate lists of
the right *structure*, not enumerate values. Try:

```mercury
my_length([], 0).
my_length([_ | Tail], N) :-
    N > 0,
    N0 = N - 1,
    my_length(Tail, N0).
```

This will need `pragma promise_equivalent_clauses` because the two modes use the same
clause set and the compiler cannot verify they are equivalent without your assertion:

```mercury
:- pragma promise_equivalent_clauses(my_length/2).
```

Test `(out, in)` mode with:
```mercury
solutions(my_length(_, 2), Lists),
io.write_line(Lists, !IO).
```

This may produce surprising output — lists of unbound variables. That is correct: the
structure (length 2) is determined, but the element values are not.

## `my_append` with three modes

```mercury
:- pred my_append(list(T), list(T), list(T)).
:- mode my_append(in, in, out) is det.
:- mode my_append(out, in, in) is multi.
:- mode my_append(in, out, in) is semidet.
:- pragma promise_equivalent_clauses(my_append/3).
```

Three behaviors from one predicate:
- `(in, in, out)`: concatenate two lists
- `(out, in, in)`: find all prefixes that could have been appended to `B` to get `C`
- `(in, out, in)`: find the suffix that follows `A` in `C` (at most one)

The clauses:
```mercury
my_append([], B, B).
my_append([H | T], B, [H | C]) :- my_append(T, B, C).
```

These clauses work for all three modes — the mode checker verifies this.

---

## Checkpoint

- Both modes of `my_length` work
- All three modes of `my_append` work
- `pragma promise_equivalent_clauses` is understood: what responsibility does it put on you?
- You can explain: why does Mercury require the pragma instead of inferring equivalence?
