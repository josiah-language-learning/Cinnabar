# Bridge: typeclass refactor

**After:** `katas/type-system/07-typeclass-design`

`expr_eval.m` is a working expression evaluator over integer arithmetic. The numeric
type is hardcoded as `int` throughout. The `env` type maps variable names to `int`.
Operations like `+`, `-`, `*`, and `//` are all `int` operations.

Build and run it first:

```
mmc --make --grade asm_fast.par.gc.stseg expr_eval
./expr_eval
```

The tasks extract the concrete `int` type into a type parameter constrained by a
`numeric` typeclass, so the same evaluator can work over `int`, `float`, and a
custom `rational` type.

---

## Extension tasks

### 1. Define the `numeric` typeclass

Define a typeclass that captures the operations the evaluator needs:

```mercury
:- typeclass numeric(N) where [
    func add(N, N) = N,
    func sub(N, N) = N,
    func mul(N, N) = N,
    func div_safe(N, N) = maybe(N),  % no if denominator is zero
    func of_int(int) = N,            % for literal conversion
    func to_string(N) = string       % for printing
].
```

Parameterize the `env` and `expr` types:

```mercury
:- type env(N) == map(string, N).
```

Change `eval` to:

```mercury
:- func eval(env(N), expr) = maybe(N) <= numeric(N).
```

At this point, the evaluator body must replace all `+`, `-`, `*`, `//` with
typeclass method calls: `add(VA, VB)`, `sub(VA, VB)`, etc.

Change `lit(int)` in the `expr` type to `lit(float)` or keep it `int` and use
`of_int` to convert — choose one approach and document the trade-off.

### 2. Write the `int` instance

```mercury
:- instance numeric(int) where [
    add(A, B)      = A + B,
    sub(A, B)      = A - B,
    mul(A, B)      = A * B,
    div_safe(A, B) = ( B = 0 -> no ; yes(A // B) ),
    of_int(N)      = N,
    to_string(N)   = string.int_to_string(N)
].
```

Verify the original test cases still produce the same results.

### 3. Write the `float` instance

```mercury
:- instance numeric(float) where [
    ...
    div_safe(A, B) = ( B = 0.0 -> no ; yes(A / B) ),
    of_int(N)      = float(N),
    ...
].
```

Test with the same expression trees — `x + 5`, `x / y`, `x / 0` — but using a
float environment: `["x" - 10.0, "y" - 3.0]`.

Division by `0.0` in Mercury produces infinity, not an error. Your `div_safe` can
test `B = 0.0` to detect this before dividing.

### 4. Write the `rational` instance

Define a `rational` type:

```mercury
:- type rational ---> rational(int, int).  % numerator, denominator
```

Maintain the invariant that the denominator is always positive and the fraction is
in lowest terms. Write `make_rational(int, int) = rational` that normalises by
dividing both by GCD and ensuring denominator > 0. You will need a GCD function.

Implement `numeric(rational)`. Division is exact: `rational(a, b) / rational(c, d) = rational(a*d, b*c)`.

`div_safe(A, B)` returns `no` when `B = rational(0, _)`.

Verify that `eval` with a rational environment correctly evaluates `x / y` to
an exact fraction rather than truncating.

---

## What you are practising

- Identifying the "interface" hidden in concrete code and expressing it as a typeclass
- Method names in typeclass instances must not shadow existing Mercury stdlib functions
- `of_int` as the bridge between the hardcoded `lit(int)` and a polymorphic numeric
- The `rational` instance shows that the evaluator gains correctness (exact division)
  without any change to its code — the typeclass abstraction earned its keep
