# Koan: module name mismatch

## Prerequisites
- `katas/tooling/01-grades`

This file is saved as `mod_name_koan.m`. The module declaration says something different.

```
mmc --make mod_name_koan
```

The compiler rejects it before reading a single predicate.

---

Mercury requires the module name to match the filename exactly:

| Filename | Required module declaration |
|---|---|
| `foo.m` | `:- module foo.` |
| `bar_baz.m` | `:- module bar_baz.` |
| `my.module.m` | `:- module my.module.` |

`mmc --make` locates source files by converting module names to filenames. A mismatch means any module that imports `mod_name_koan` cannot find it, and any attempt to build `mod_name_koan` directly hits the declared name. The error appears immediately.

**Fix:** change the module declaration to match the filename, or rename the file to match the module declaration.

---

## What to observe

The error fires at the very first line of the file — the module declaration — before
the compiler reads any predicate or type. `mmc --make` derives the expected module
name from the filename before opening the file. A mismatch is detected immediately.

---

## Your task

Fix the mismatch — either change the `:- module` declaration or rename the file.
Recompile. Then try importing this module from another file with the wrong module
name and observe that the import error also appears before any predicate-level check.
