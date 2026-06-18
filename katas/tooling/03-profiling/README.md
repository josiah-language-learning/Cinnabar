# 03 — Profiling: flat vs deep

**Concept:** `.prof` and `.profdeep` grades, `mdprof_feedback`, flat vs. deep profiling
attribution, identifying hotspots

---

## The program: naive vs memoized Fibonacci

```mercury
:- module fib_profile.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.

:- func fib_naive(int) = int.
fib_naive(0) = 0.
fib_naive(1) = 1.
fib_naive(N) = fib_naive(N - 1) + fib_naive(N - 2).

:- func fib_memo(int) = int.
:- pragma memo(fib_memo/1).
fib_memo(0) = 0.
fib_memo(1) = 1.
fib_memo(N) = fib_memo(N - 1) + fib_memo(N - 2).

main(!IO) :-
    N = 35,
    R1 = fib_naive(N),
    io.format("fib_naive(%d) = %d\n", [i(N), i(R1)], !IO),
    R2 = fib_memo(N),
    io.format("fib_memo(%d) = %d\n", [i(N), i(R2)], !IO).
```

---

## Flat profiling

```bash
mmc --make --grade asm_fast.gc.prof.stseg fib_profile
./fib_profile
gprof fib_profile gmon.out | head -40
```

Flat profiling shows:
- Which functions consumed the most *self* time
- Call counts per function

For `fib_naive(35)`, the hot function is clearly `fib_naive` — it is called 2^35 times.
For `fib_memo(35)`, `fib_memo` is called 36 times total.

Limitation of flat profiling: time is attributed to the function where it is spent, not
to the caller that caused it to be called. A function called by many different callers
appears as one aggregate entry — you cannot tell which caller is the cause.

## Deep profiling

```bash
mmc --make --grade asm_fast.gc.profdeep.stseg fib_profile
./fib_profile
mdprof_feedback --desired-parallelism 1.0 fib_profile.data fib_profile.feedback
mdprof_report fib_profile.data > profile_report.txt
```

**Note:** profiling grades (`asm_fast.gc.prof.stseg`, `asm_fast.gc.profdeep.stseg`) must be
compiled into your Mercury installation. They are not included in the default cinnabar dev shell.
If the build fails with a grade-not-found error, check your Mercury installation's available grades.

Deep profiling attributes time to call chains — each unique call path gets its own entry.
This identifies not just *what* is hot but *why* (which call path leads to it).

For this program the call chains are short, but for a real program with shared utility
predicates called from many sites, deep profiling is substantially more informative.

---

## Checkpoint

- Flat profile run completes; `gprof` output shows `fib_naive` dominating
- Deep profile run completes; `mdprof_report` output is readable
- Memoized version is visibly faster (measure with `time ./fib_profile` before and after)
- You can explain: when would flat profiling mislead you but deep profiling would not?
