# Solution notes

## Task 1: reverse mode

Replace the single declaration with two mode declarations and two clause bodies:

```mercury
:- pred str_to_int(string, int).
:- mode str_to_int(in, out) is semidet.
:- mode str_to_int(out, in) is det.
:- pragma promise_equivalent_clauses(str_to_int/2).

str_to_int(S::in,  N::out) :- string.to_int(S, N).
str_to_int(S::out, N::in)  :- S = string.int_to_string(N).
```

Mode-specific syntax: each clause head annotates its arguments with `::mode`.
Mercury picks the correct clause at compile time based on which arguments are ground
at the call site.

The pragma is valid here because both clauses compute the same relation: `(S, N)` is
a valid pair iff `S` is the decimal representation of `N`. The relation is the same;
only the direction of computation differs.

In `main`, the reverse mode looks like any other call:
```mercury
str_to_int(SOf42, 42),  % SOf42 = "42"
io.format("Reverse: %d => \"%s\"\n", [i(42), s(SOf42)], !IO),
```

## Task 2: why the third mode breaks the promise

A `(out, out) is nondet` mode would need to generate all pairs `(S, N)` where `S`
is a valid decimal representation of `N`. The set of such pairs is infinite (one pair
per integer). There is no finite way to enumerate it in Mercury.

More importantly: `promise_equivalent_clauses` asserts that all mode-specific clauses
compute the same logical relation. The third mode would not violate the relation — the
same pairs are valid — but the determinism is wrong. The forward mode is `semidet`
(at most one N for a given S). The reverse mode is `det` (exactly one S for a given N).
A nondet mode is not the same logical object as these two.

In practice: write a separate predicate with a different name if you need generation.
Do not try to coerce `promise_equivalent_clauses` into covering incompatible
determinisms.

## Task 3: `version_array` round-trip

```mercury
:- import_module int.
:- import_module version_array.

:- pred strings_to_array(list(string)::in, version_array(int)::out) is det.
strings_to_array(Strings, Array) :-
    N = list.length(Strings),
    list.foldl2(
        (pred(S::in, Idx::in, NextIdx::out, VA0::in, VA::out) is det :-
            NextIdx = Idx + 1,
            ( str_to_int(S, V) ->
                VA = version_array.set(VA0, Idx, V)
            ;
                VA = VA0  % leave default 0
            )),
        Strings, 0, _, version_array.init(N, 0), Array).

:- pred array_to_strings(version_array(int)::in, list(string)::out) is det.
array_to_strings(Array, Strings) :-
    N = version_array.size(Array),
    list.map(
        (pred(Idx::in, S::out) is det :-
            V = version_array.lookup(Array, Idx),
            str_to_int(S, V)),  % reverse mode: V::in, S::out
        0 `..` (N - 1), Strings).
```

`0 `..` (N - 1)` uses the `int.(..)` range operator to produce `list(int)`.
Import `int` for this syntax.

The reverse mode call `str_to_int(S, V)` with `V::in` (ground) and `S::out` (free)
is selected automatically by Mercury based on instantiation. No special syntax needed
at the call site — Mercury resolves it at compile time.

`version_array.lookup(Array, Idx)` reads without consuming `Array`. With `array(T)`,
you would need to pass the array in `in` mode and write carefully — here the
persistent semantics make the code straightforward.
