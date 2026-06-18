# Solution: use `//` for integer division

`/` is overloaded for numeric types in Mercury, but only for `float`. Integer division
uses a separate operator `//` to make it explicit that truncation toward zero occurs.

```mercury
% Before (broken):
average(A, B) = (A + B) / 2.

% After (fixed):
average(A, B) = (A + B) // 2.
```

## `rem` vs `mod`

For `A = -7, B = 3`:
- `A rem B = -1` (sign follows the dividend: -7)
- `A mod B = 2`  (sign follows the divisor: 3)

`rem` behaves like C's `%` — the remainder has the same sign as the dividend.
`mod` behaves like Python's `%` — the remainder has the same sign as the divisor.

For a circular buffer or modular arithmetic where you always want a non-negative result,
use `mod`. For compatibility with C-style remainder semantics, use `rem`.
