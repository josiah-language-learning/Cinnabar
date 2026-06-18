# 05 — Deadlock patterns and avoidance

**Concept:** the waiting-for graph; semaphore mutexes; resource ordering as deadlock
prevention; `mvar` for shared state

**Not in the Mercury tutorial.**

---

## What causes deadlock

Deadlock requires a *cycle* in the "waiting-for" graph. The classic case:

> Thread A holds resource 1 and waits for resource 2.  
> Thread B holds resource 2 and waits for resource 1.  
> Neither can proceed.

A second pattern uses blocking channels:

> Thread A writes to channel 1 and reads from channel 2.  
> Thread B writes to channel 2 and reads from channel 1.  
> Both write-and-block before reading, so both block forever.

---

## Semaphore as a mutex

`thread.semaphore` provides the mutex primitive. A semaphore starts at 1 ("unlocked").
`wait` decrements it (blocks if 0); `signal` increments it (releases the lock):

```mercury
mutex_init(M, !IO) :-
    semaphore.init(M, !IO),
    semaphore.signal(M, !IO).    % initial signal = unlocked

counter_inc(C, M, !IO) :-
    semaphore.wait(M, !IO),      % acquire
    mvar.take(C, N, !IO),
    mvar.put(C, N + 1, !IO),
    semaphore.signal(M, !IO).    % release
```

The `mvar` holds the counter value. `take` removes the value (blocks until available);
`put` deposits it back. Together with the semaphore, this makes increment atomic.

---

## Resource ordering: the canonical fix

To break the cycle, always acquire resources in a *fixed global order*:

> If every thread acquires mutex A before mutex B, no cycle can form.
> Thread 1 holds A, waits for B. Thread 2 also holds A — but it must wait for Thread 1.
> No cycle. No deadlock.

In the `transfer` exercise: always acquire the source mutex before the destination
mutex. If both threads do this, the first thread to acquire the source proceeds while
the second blocks, then the second proceeds after the first completes.

---

## What you will build

### `counter_init`, `mutex_init`

Initialize an `mvar(int)` counter to 0 and a semaphore mutex to the "unlocked" state.

### `counter_inc(counter, mutex, !IO)`

Atomically increment the counter: wait (acquire), take, increment, put, signal (release).

### `spawn_incrementors(N, K, counter, mutex, !IO)` — `cc_multi`

Spawn N threads, each calling `increment_k_times(K, ...)`. This predicate calls
`thread.spawn`, so it must be declared `cc_multi`.

### `transfer(from, to, amount, mutex_from, mutex_to, !IO)` — `det`

Transfer `amount` from one counter to another. Acquire both mutexes (source first,
destination second — resource ordering), do the transfer, release both.

---

## Why `cc_multi`?

`thread.spawn` has mode `cc_multi`. Any predicate that calls `thread.spawn` must also
be `cc_multi` or `cc_nondet`. This propagates: `spawn_incrementors` calls `thread.spawn`,
so it must be `cc_multi`; `main` calls `spawn_incrementors`, so `main` must also be
`cc_multi`.

---

## Checkpoint

- 3 sequential increments give a counter value of 3
- N threads × K increments give N×K (with the mutex preventing races)
- The transfer moves the correct amount without deadlock
- You can state: what structural property causes deadlock?
- You can state: why does resource ordering prevent deadlock?
