# Generic printer solution notes

## `deconstruct` vs typeclass

The RTTI approach works for any type without modification. But it has costs:

- **No compile-time checking:** if you add a type to your system and it has a weird
  `deconstruct` representation, you only find out at runtime.
- **No customization:** you cannot make an `int` print as `"42"` instead of `"42"` —
  the functor IS the representation.
- **Performance:** RTTI calls are slower than direct pattern matching.

The typeclass approach (`printable` from `katas/type-system/04-type-classes`) requires
an instance per type but gives you full control over formatting and compile-time safety.

Use RTTI for debugging tools and generic infrastructure. Use typeclasses for
user-facing display.

## The `canonicalize` flag

`deconstruct(V, canonicalize, ...)` normalizes the representation — for example,
it represents `[1,2,3]` as `'[|]'(1, '[|]'(2, '[|]'(3, '[]')))` consistently.
The alternative `include_details_cc` gives more information for debugging but is
`cc_multi` rather than `det`.
