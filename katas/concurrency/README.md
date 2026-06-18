# Concurrency

Mercury supports two concurrency models: **parallel conjunction** (`&`) for
fork-join parallelism over `det` computations, and **threads** (`thread.spawn`,
`thread.channel`) for independent concurrent tasks communicating through channels.

Both require the `.par` grade.

| Kata | Topic |
|---|---|
| `01-parallel-conjunction/` | `&` operator, `det`/`cc_multi` requirement, timing comparison |
| `02-threads/` | `thread.spawn`, `thread.channel`, producer-consumer |

**Not in the Mercury tutorial.**
