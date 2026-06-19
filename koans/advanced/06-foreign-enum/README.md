# Koan: `pragma foreign_enum` with incomplete constructor mapping

**Broken concept:** a `pragma foreign_enum` declaration that maps a Mercury
discriminated union type to C enum values, but omits one of the constructors —
Mercury requires complete coverage, the same guarantee as `require_complete_switch`

## Prerequisites

- `katas/advanced/01-ffi-depth` — `foreign_type`, `foreign_enum`, C type bindings
- `katas/type-system/01-discriminated-unions` — discriminated unions and constructors

---

`pragma foreign_enum("C", type/0, [ctor - "C_VALUE", ...])` binds each
constructor of a Mercury type to a C constant. Mercury uses this information
to translate values between Mercury and C at the FFI boundary.

The mapping must be *complete*: every constructor in the type's definition
must appear in the foreign_enum list. If any constructor is missing, there is
no C value to use for that constructor, and the mapping is unsound.

---

## Try it

```
mmc --make foreign_enum_koan
```

The compiler reports that `yellow` does not have a foreign value in the mapping.

---

## What to observe

`color` has four constructors: `red`, `green`, `blue`, `yellow`. The pragma
lists C values for `red`, `green`, and `blue` but omits `yellow`. The compiler
catches this at the pragma declaration site — the same static completeness
check as `require_complete_switch` for match expressions.

---

## Your task

Add the missing constructor `yellow - "COLOR_YELLOW"` to the foreign_enum list.
