# Solution notes

## Task 1: the `numeric` typeclass and parameterized eval

```mercury
:- typeclass numeric(N) where [
    func num_add(N, N) = N,
    func num_sub(N, N) = N,
    func num_mul(N, N) = N,
    func div_safe(N, N) = maybe(N),
    func of_int(int) = N,
    func to_string(N) = string
].

:- type env(N) == map(string, N).

:- func eval(env(N), expr) = maybe(N) <= numeric(N).
eval(_, lit(K))      = yes(of_int(K)).
eval(Env, var(Name)) = ( map.search(Env, Name, V) -> yes(V) ; no ).
eval(Env, neg(E))    = map_maybe((func(V) = num_sub(of_int(0), V)), eval(Env, E)).
eval(Env, add(A, B)) =
    bind_maybe(eval(Env, A), (func(VA) =
        map_maybe((func(VB) = num_add(VA, VB)), eval(Env, B)))).
% sub, mul follow the same pattern
eval(Env, div(A, B)) =
    bind_maybe(eval(Env, A), (func(VA) =
        bind_maybe(eval(Env, B), (func(VB) = div_safe(VA, VB))))).
```

Method names: do not use `add`, `sub`, `mul` — these shadow Mercury's stdlib
arithmetic. Prefix with `num_` or use longer names. The typeclass checker will
accept shadowed names, but call sites become ambiguous at the use point.

`lit(int)` stays as `lit(int)` and the `of_int` method converts to the numeric
type. This means literals are always given as integers and converted — which works
for `int` (identity), `float` (exact), and `rational` (exact). The trade-off:
`lit(float)` would allow non-integer literals like `3.14`, which `of_int` cannot
represent.

## Task 2: `int` instance

```mercury
:- instance numeric(int) where [
    num_add(A, B)  = A + B,
    num_sub(A, B)  = A - B,
    num_mul(A, B)  = A * B,
    div_safe(A, B)  = ( B = 0 -> no ; yes(A // B) ),
    of_int(N)      = N,
    to_string(N)      = string.int_to_string(N)
].
```

## Task 3: `float` instance

```mercury
:- instance numeric(float) where [
    num_add(A, B)  = A + B,
    num_sub(A, B)  = A - B,
    num_mul(A, B)  = A * B,
    div_safe(A, B)  = ( B = 0.0 -> no ; yes(A / B) ),
    of_int(N)      = float(N),
    to_string(F)      = string.float_to_string(F)
].
```

Note: `float(N)` is Mercury's built-in integer-to-float coercion function.
`A / B` on floats uses single-slash (float division), not `//` (integer division).

## Task 4: `rational` instance

```mercury
:- type rational ---> rational(int, int).  % numerator, denominator; denom > 0

:- func gcd(int, int) = int.
gcd(A, 0) = A.
gcd(A, B) = gcd(B, A rem B) :- B \= 0.

:- func make_rational(int, int) = rational.
make_rational(_, 0) = rational(0, 1).  % degenerate: 0/0 → 0
make_rational(N, D) = rational(N2, D2) :-
    Sign = ( D < 0 -> -1 ; 1 ),
    G    = gcd(int.abs(N * Sign), int.abs(D)),
    N2   = (N * Sign) // G,
    D2   = int.abs(D) // G.

:- instance numeric(rational) where [
    num_add(rational(N1,D1), rational(N2,D2)) =
        make_rational(N1*D2 + N2*D1, D1*D2),
    num_sub(rational(N1,D1), rational(N2,D2)) =
        make_rational(N1*D2 - N2*D1, D1*D2),
    num_mul(rational(N1,D1), rational(N2,D2)) =
        make_rational(N1*N2, D1*D2),
    div_safe(rational(N1,D1), rational(N2,D2)) =
        ( N2 = 0 -> no ; yes(make_rational(N1*D2, D1*N2)) ),
    of_int(N)         = rational(N, 1),
    to_string(rational(N, D)) = string.int_to_string(N) ++ "/" ++ string.int_to_string(D)
].
```

With a rational environment `["x" - rational(10,1), "y" - rational(3,1)]`, the
expression `x / y` evaluates to `yes(rational(10, 3))` — exact, not truncated to 3.
The evaluator code is unchanged. The typeclass earned its abstraction.

One gotcha: Mercury instance methods must be function definitions or predicate
definitions, not arbitrary expressions. If a method body is too complex for a single
expression, define a helper function and call it from the instance.
