# Solution: add the missing constructor to the `foreign_enum` mapping

## The error

```
foreign_enum_koan.m: In `:- pragma foreign_enum' declaration for type `color'/0:
    error: the following constructor does not have a foreign value:
        `yellow'.
```

The mapping covers `red`, `green`, and `blue` but not `yellow`. Mercury requires
total coverage: if any constructor can appear at runtime, the FFI layer needs a
C value to send across the boundary. A partial mapping would be unsafe.

## The fix

```mercury
:- pragma foreign_enum("C", color/0,
    [red    - "COLOR_RED",
     green  - "COLOR_GREEN",
     blue   - "COLOR_BLUE",
     yellow - "COLOR_YELLOW"]).
```

The C constants (`COLOR_RED`, etc.) must be defined in the C compilation
environment — here via `pragma foreign_decl`. In a real project they would
typically come from an `#include`d header.

## `foreign_enum` vs `foreign_type`

`pragma foreign_type` maps an entire Mercury type to an opaque C type (e.g., `FILE *`).
`pragma foreign_enum` maps a Mercury discriminated union *with only nullary constructors*
to C enum integer constants — Mercury controls the constructors, C controls the values.

Use `foreign_enum` when:
- The type is defined in Mercury (you own the constructors)
- You need the Mercury values to pass through a C API that expects specific enum integers
- You want Mercury's type system to enforce valid enum values rather than passing raw ints

The completeness check at compile time means adding a new constructor to the Mercury
type forces you to add a mapping entry — the C API and the Mercury type stay in sync.
