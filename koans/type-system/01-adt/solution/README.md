# Solution: add the missing constructor case

```mercury
:- func area(shape) = float.
area(square(S))       = S * S.
area(rectangle(W, H)) = W * H.
area(triangle(B, H))  = 0.5 * B * H.   % FIX: added missing case
```

## Why this matters

If you add a new constructor to `shape` later:
```mercury
;       circle(float)
```

Every switch over `shape` becomes non-exhaustive again. The compiler catches all of them
at build time — not at runtime when a `circle` finally reaches a switch that only handles
squares and rectangles.

This is why discriminated unions with exhaustive switches are safer than `switch` statements
in C or match expressions in some languages that allow wildcard `_` everywhere. The
compiler is your maintenance guard.
