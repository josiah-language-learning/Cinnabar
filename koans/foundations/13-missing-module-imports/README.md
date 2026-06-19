# Koan: `io.format` format constructors — missing `import_module string`

**Broken concept:** using `i()`, `s()`, `f()`, or `c()` in `io.format` calls
without importing the module that defines them

## Prerequisites

- `katas/foundations/` — `io.format`, `io.write_string`

---

```
mmc imports_koan.m
```

The compiler reports `undefined symbol 'i'/1`. The `i()`, `s()`, `f()`, and `c()`
constructors used in `io.format` argument lists are all defined in the `string`
module — not in `io`. Even though you call `io.format`, the constructors come from
`string`.

---

## What to observe

`io.format` takes a list of `poly_type` values. The constructors `i(N)`, `s(Str)`,
`f(X)`, `c(Ch)` are all part of the `poly_type` type defined in `string`:

```mercury
:- type poly_type
    --->  f(float)
    ;     i(int)
    ;     s(string)
    ;     c(char).
```

Without `import_module string`, none of these constructors are visible.

---

## Common missing imports

| What you wrote | What was missing |
|---|---|
| `i(N)` or `s(Str)` in `io.format` | `import_module string` |
| `[i(N)]` argument list in `io.format` | `import_module list` |
| `char.to_upper(C)` | `import_module char` |
| `bool.not(B)` / `yes` / `no` | `import_module bool` |
| `math.log(X)` / `math.sqrt(X)` | `import_module math` (NOT `float`) |
| `unit` type / `unit::out` in a lambda | `import_module unit` |

`float.log` and `float.sqrt` do not exist — those functions are in `math`.

**Two layers in `io.format` calls:** `[i(N)]` involves two separate imports.
The constructor `i(N)` comes from `import_module string` (it's a `poly_type`
constructor). The list literal `[i(N)]` is syntactic sugar for `[|](i(N), [])`
— a Mercury list — which requires `import_module list`. Omitting either one
produces an `undefined symbol` error, but for different names: `'i'/1` vs
`'[|]'/2`.

---

## Your task

Add the missing `import_module` declaration that makes `i()` visible.
