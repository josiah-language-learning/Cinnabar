# 08 — Built-in types: the corners

**Concept:** integer division, `rem` vs `mod`, float literals, `io.format` poly-type
tagging, `char` vs `string`, `int.max_int`, bitwise operators

**Tutorial cross-reference:** Mercury Tutorial §2–3 introduces these types. This kata
targets the corners the tutorial does not dwell on — the parts most likely to cause a
subtle bug or a confusing compile error.

---

## Integer division: `//` not `/`

```mercury
% This is a type error:
X = 7 / 2.

% This is correct:
X = 7 // 2.    % integer division, rounds toward zero
```

`/` is defined for `float` but not `int`. The compiler error ("type error ... expected
float, got int") is initially confusing. Write a small program that triggers it, read the
error, then fix it.

## `rem` vs `mod` on negatives

Both compute a remainder, but they differ on negative operands:

```mercury
:- func rem_demo(int, int) = string.
rem_demo(A, B) = string.format("%d rem %d = %d, %d mod %d = %d",
    [i(A), i(B), i(A rem B), i(A), i(B), i(A mod B)]).
```

Try: `rem_demo(-7, 3)` and `rem_demo(7, -3)`.

- `rem` has the same sign as the dividend (like C's `%`)
- `mod` has the same sign as the divisor (like Python's `%`)

Write a predicate that wraps an index into a circular buffer — which one do you want?

## Float literals

Mercury float literals require a decimal point:

```mercury
X = 1.0.      % ok
Y = 1.        % ok (trailing dot)
Z = 1.        % this is ambiguous with module-qualified names — prefer 1.0
```

`float(N)` converts an `int` to `float`. Explicit conversion is required — Mercury has no
implicit numeric widening.

## `io.format` poly-type tagging

`io.format` takes a format string and a `list(io.poly_type)`. Each value must be tagged:

| Tag | Type |
|-----|------|
| `i(N)` | `int` |
| `f(X)` | `float` |
| `s(Str)` | `string` |
| `c(Ch)` | `char` |

```mercury
io.format("Name: %s, Age: %d, Score: %.2f\n",
    [s("Alice"), i(30), f(98.6)], !IO).
```

Write a formatter that prints an `item` record (name, price, qty) using `io.format` with
all four tag types.

## `char` vs `string`

A `char` is a single Unicode codepoint; a `string` is a sequence of code units. They are
different types — a single-character string is not a char:

```mercury
C = 'a'.              % char
S = "a".              % string
% These have different types. You cannot use one where the other is expected.
```

Convert: `char.to_string(C)` gives `"a"`. `string.det_first_char(S)` gives the first char
(crashes on empty string). `string.to_char_list(S)` gives `list(char)`.

## `int.max_int`, `int.pow`, bitwise ops

Explore these predicates from the `int` module:
```mercury
int.max_int           % largest int for this platform
int.pow(2, 10)        % 1024 — power function, not ** (no ** in Mercury)
int.xor(A, B)         % bitwise XOR
A /\ B                % bitwise AND
A \/ B                % bitwise OR
\ A                   % bitwise complement
```

Write a function `count_bits(int) = int` that counts set bits using repeated bitwise AND
and shift. Note: Mercury uses `unchecked_right_shift`/`unchecked_left_shift` — read why
they are "unchecked."

---

## Checkpoint

- You have triggered and understood the type error from `7 / 2`
- `rem` vs `mod` demo outputs the correct values for negative cases
- `io.format` call with all four tag types compiles and runs
- `count_bits` works for at least `0`, `1`, `255`, `256`
