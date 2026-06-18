# 01 — FFI depth: all four pragma types

**Concept:** `foreign_decl`, `foreign_type`, `foreign_proc`, `foreign_export`, FFI
attributes (`will_not_call_mercury`, `thread_safe`, `tabled_for_io`)

**Not in the Mercury tutorial.**

---

## Background

Mercury's FFI has four pragma types:

| Pragma | Purpose |
|--------|---------|
| `foreign_decl` | C declarations (headers, struct forward declarations) |
| `foreign_type` | Map a C type to a Mercury type |
| `foreign_proc` | Implement a Mercury predicate in C |
| `foreign_export` | Export a Mercury predicate to be called from C |

---

## What you will build

A wrapper for `gettimeofday(2)` — get the current time as microseconds.

### Step 1: `foreign_decl`

```mercury
:- pragma foreign_decl("C", "
    #include <sys/time.h>
    #include <stdint.h>
").
```

This includes the C header in the generated C file.

### Step 2: `foreign_type`

Map `struct timeval` to a Mercury type:

```mercury
:- type timeval.
:- pragma foreign_type("C", timeval, "struct timeval").
```

The Mercury type `timeval` is opaque — Mercury code cannot inspect its fields. Only
`foreign_proc` implementations can access the underlying C struct.

### Step 3: `foreign_proc`

```mercury
:- pred get_time_of_day(int::out, io::di, io::uo) is det.
:- pragma foreign_proc("C",
    get_time_of_day(Microseconds::out, _IO0::di, _IO::uo),
    [will_not_call_mercury, promise_pure, thread_safe, tabled_for_io],
    "
        struct timeval tv;
        gettimeofday(&tv, NULL);
        Microseconds = (MR_Integer)(tv.tv_sec * 1000000LL + tv.tv_usec);
    ").
```

FFI attributes explained:
- `will_not_call_mercury` — the C code does not call back into Mercury; allows the
  runtime to skip some locking. **Without this, Mercury acquires a mutex on every
  foreign call.**
- `promise_pure` — the Mercury implementation of this predicate is pure (even though
  the C implementation has side effects)
- `thread_safe` — the C code is thread-safe (no unsynchronized global state)
- `tabled_for_io` — IO effects are tabled; consistent with IO uniqueness model

### Step 4: `foreign_export`

Export a Mercury predicate to be callable from C:

```mercury
:- pred print_time(int::in, io::di, io::uo) is det.
print_time(Us, !IO) :-
    io.format("Time: %d us\n", [i(Us)], !IO).

:- pragma foreign_export("C", print_time(in, di, uo), "mercury_print_time").
```

Write a C `main` (or a `foreign_proc` test) that calls `mercury_print_time`.

### Step 5: Wire it together

```mercury
main(!IO) :-
    get_time_of_day(T1, !IO),
    % ... do some work ...
    get_time_of_day(T2, !IO),
    io.format("Elapsed: %d us\n", [i(T2 - T1)], !IO).
```

---

## Checkpoint

- All four pragma types compile without errors
- `get_time_of_day` returns a plausible microsecond timestamp
- You can explain: what goes wrong at runtime if you omit `will_not_call_mercury` on a
  call-heavy FFI binding?
- You can explain: what does `tabled_for_io` mean and why is it needed here?
