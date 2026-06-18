# Koan: higher-order inst annotation is mandatory

**Broken concept:** storing a predicate in a variable without an inst annotation, then
attempting to call it via `call/2`

## Prerequisites

- `katas/foundations/04-higher-order` — storing predicates in variables, inst annotations, `call/N`

---

Mercury's mode system needs to know the *inst* of a higher-order value before it can
call it — specifically, whether the stored value is a concrete predicate (and with what
mode). Without the inst, the compiler does not know how to check the call.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg ho_koan
```

The error will mention something about the mode of the higher-order argument — the
variable's inst is `ground` or `any` rather than the specific `pred(in, out) is det`
inst that `call/2` requires.

---

## Your task

Fix the code so that `Transform` is correctly annotated with its inst. You can either:
1. Annotate the type of `Transform` with `is det`
2. Change the variable assignment to use an inline lambda with the correct inst
3. Use a named inst declaration

The solution uses approach 3 (named inst) as the most reusable form.
