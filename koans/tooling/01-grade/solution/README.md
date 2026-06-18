# Solution

This koan has no broken source file — the error is in the build command, not the code.

**The fix:** recompile with `.debug` in the grade string:

```bash
mmc --make --grade asm_fast.gc.debug.stseg my_program
mdb ./my_program
```

Note that `.par` is dropped from the grade. You can combine `.debug` and `.par`
(`asm_fast.par.gc.debug.stseg`) but debug+parallel builds are rare in practice.
The key invariant: every feature you want must appear as a grade component.
