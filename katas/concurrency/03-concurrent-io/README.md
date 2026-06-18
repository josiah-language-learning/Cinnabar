# Kata: concurrent IO with thread.spawn

`thread.spawn` creates a new OS thread. Unlike `&` (parallel conjunction), spawning does not share the parent's IO token — the child receives its own independent IO thread. This is what makes it safe.

```mercury
:- import_module thread.

thread.spawn(
    pred(!.IO::di, !:IO::uo) is det :- worker(!IO),
    !IO
)
```

After `spawn` returns, the parent continues with its own IO token. The spawned thread runs concurrently. There is no implicit join.

## Synchronisation: semaphore

The `semaphore` module provides a counting semaphore for coordinating threads:

```mercury
:- import_module semaphore.

semaphore.init(Sem, !IO)    % create semaphore (initial count 0)
semaphore.signal(Sem, !IO)  % increment count
semaphore.wait(Sem, !IO)    % decrement count; blocks if count is 0
```

The basic join pattern:

```mercury
semaphore.init(Done, !IO),
thread.spawn(pred(!.IO::di, !:IO::uo) is det :-
    do_work(!IO),
    semaphore.signal(Done, !IO),
    !IO),
semaphore.wait(Done, !IO).
```

## Shared mutable state: io.mutvar

When threads need shared state, use `io.mutvar`:

```mercury
io.new_mutvar(Initial, Var, !IO)
io.get_mutvar(Var, Value, !IO)
io.set_mutvar(Var, Value, !IO)
```

`mutvar` operations go through `!IO`, so they are sequenced within each thread but not across threads. Use a semaphore as a mutex when multiple threads write to the same mutvar.

## Steps

### 1. Spawn and wait

Spawn a single thread that prints `"worker done\n"` then signals a semaphore. Have main wait on that semaphore before printing `"main done\n"`. Verify ordering.

### 2. Spawn N workers

Spawn five threads, each printing its index. Wait for all five using a single semaphore (count starts at 0; each worker signals once; main waits five times).

### 3. Parallel sum

```mercury
:- pred parallel_sum(list(int)::in, int::out, io::di, io::uo) is det.
```

Split the list in half, sum each half in a separate thread, add results. Use a `mutvar` to communicate each partial sum back to the parent.

### 4. Mutex pattern

Two threads each increment a shared counter 1000 times. Without a mutex the result is unpredictable. Add a semaphore (initial count 1) used as a binary mutex around each read-modify-write cycle. Verify the final count is 2000.

## Getting started

```mercury
:- module concurrent_io.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module int.
:- import_module list.
:- import_module semaphore.
:- import_module thread.

main(!IO) :- true.
```

Note: concurrent execution requires a parallel grade. Build with:

```
mmc --grade asm_fast.par.gc --make concurrent_io
```

or configure the grade in your `Mercury.options` file.
