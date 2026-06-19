# Solution

Add `import_module string` to the implementation section.

The `i()`, `s()`, `f()`, `c()` constructors come from `string.poly_type`. The `io`
module exports `io.format/4` but does not re-export the constructors — you must
import `string` yourself.

```mercury
:- import_module string.
```

A useful rule of thumb: if `io.format` compiles but the format-arg constructors
don't, you are almost certainly missing `import_module string`.

See the koan README for a table of other commonly missing imports (`char`, `bool`,
`math`, `unit`).
