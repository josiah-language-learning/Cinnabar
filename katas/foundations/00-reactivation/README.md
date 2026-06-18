# 00 — Reactivation

Seven short programs, one concept each. The goal is not to read them — it is to predict them first, then read them, then account for the gap between what you expected and what you found.

## The method

For each exercise:

1. Read the exercise README. It tells you which Mercury concept the program demonstrates and gives you a sentence or two of context — enough to form a prediction, not enough to give it away.
2. **Write down** what you expect the program to do and how. Two or three sentences is enough. Do this before opening the `.m` file.
3. Open the `.m` file and read it.
4. Note what surprised you. Anything the program does that you did not predict, any syntax you had to look up, any mode or determinism annotation that wasn't what you expected — write it down. One sentence per surprise is fine.

The gap between prediction and reality is the actual learning. Passive reading closes no gaps.

## Toolchain check

Before working through the exercises, confirm your Mercury compiler is alive. In this directory, or any exercise subdirectory, run:

```
mmc --make --grade asm_fast.par.gc.stseg hello
```

(or whichever module you're building). If the grade flag is not needed on your system, `mmc --make hello` also works. The point is to discover toolchain issues against a trivial program rather than halfway through a real one.

## Exercises

Work them in this order — it goes from simplest to most complex, and each one reactivates something the next one builds on.

| # | Directory | What it reactivates |
|---|---|---|
| 1 | `01-hello-world/` | bare module skeleton, `io.di`/`io.uo`, `!IO` threading |
| 2 | `02-fibonacci/` | recursive `det` predicate, if-then-else expression form |
| 3 | `03-daytype/` | multi-clause disjunctive `func`, `io.read_from_string`, `command_line_arguments` |
| 4 | `04-sillylist/` | functor/operator overloading — read the note in that README before predicting |
| 5 | `05-cast-of-characters/` | named-field ADTs, `^field` access, named-pred vs. inline-lambda `foldl` |
| 6 | `06-pure-randomness/` | `mutable`, `impure`/`semipure`, `foreign_proc`, `:- initialize` |
| 7 | `07-zookeeper-puzzle/` | the capstone: `multi`/`det` mode pairs, `nondet`, `solutions/2`, `<=>`, negation-as-failure |

## After the reading pass

Once you have worked through all seven, move to `active-recall/` for one short programming exercise. Do not skip it — reading and writing activate different things.
