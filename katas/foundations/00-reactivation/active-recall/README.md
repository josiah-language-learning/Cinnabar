# Active Recall

Reading activates recognition. Writing activates retrieval. This exercise is the retrieval pass — you are going to write Mercury, not read it.

Pick one option. The light option drills pattern-matching and if-then-else. The heavy option drills the `nondet` generate-and-test idiom — the same one Stage 0.0 ends on and Stage 2 of a quality-based narrative engine will depend on.

---

## Option A — Light: extend `daytype`

Extend `daytype.m` with one more distinction. For example: split "workday" into "school night" (Sunday through Thursday) vs. "not a school night" (Friday and Saturday), based on a second command-line argument indicating whether the user is a student.

What this drills:
- Adding a clause to a multi-clause `func`
- Compound if-then-else with multiple conditions
- Parsing and using a second command-line argument
- Keeping determinism annotations correct as you add cases

Done when: the extended program compiles, the new cases produce the right output, and you can explain which mode and determinism annotation you chose for any new predicates you added.

---

## Option B — Heavy: extend the zookeeper puzzle

Add a fourth house to `zookeeper_puzzle.m`. The original has three houses, three attributes per house (race, color, pet), and a set of clues. Add one more attribute to each house (e.g., a drink or a nationality), add one or two new clues constraining it, and confirm the puzzle still has exactly one solution.

What this drills:
- Extending a `nondet` generate-and-test — the thing you are about to rely on for logic-based eligibility checking
- Adding new dimensions to a constraint problem without breaking existing solutions
- Writing `multi` predicates that generate, and `semidet` predicates that test
- Reading the compiler's mode and determinism errors when you get something wrong (you will get something wrong)

Done when: the extended puzzle compiles, produces the correct single solution, and you can describe what would happen if you removed one of the new clues (more solutions, or no solutions — check both by temporarily removing different clues and observing the output).

---

## Which option

If you are unsure: do Option B. It is harder, but it is the direct rehearsal for the mode/determinism work in the katas that follow. Understanding `nondet` generate-and-test from the inside — having written it, broken it, and fixed it — is different from understanding it from reading.
