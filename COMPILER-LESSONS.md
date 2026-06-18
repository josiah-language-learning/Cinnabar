# Mercury compiler lessons learned

Bugs encountered while building this curriculum's examples, grouped by category.
Each entry is: what went wrong, what Mercury actually said, and what fixed it.

---

## 1. Build system and toolchain

### `mkinit: not found` when calling `mmc` directly

**Symptom:** `mmc --make` fails immediately with `sh: mkinit: not found`.

**Cause:** `mmc` shells out to several companion tools (`mkinit`, `mld`, etc.) that
must be on PATH. Calling `/nix/store/.../bin/mmc` directly without adding the
mercury `bin/` directory to PATH means the companion tools are not found.

**Fix:** `export PATH=/nix/store/.../mercury-22.01.8/bin:$PATH` before calling `mmc`,
not just a direct path to the binary.

---

### `R_X86_64_32 relocation` linker error with `asm_fast` grade

**Symptom:**
```
ld: Mercury/os/start.o: relocation R_X86_64_32 against `.text' can not be used
when making a PIE object; recompile with -fPIE
```

**Cause:** The `asm_fast` grade emits x86 assembly using absolute addresses. Modern
Linux defaults to position-independent executables (PIE), which require relative
addressing. Outside a Mercury-aware build environment, the system linker uses PIE
mode by default.

**Fix:** Use the Mercury build that has its own linker configuration (the `nix develop`
shell sets this up). In this project: `c9qll4rka99zid2hzlxkkvpcrnnvrf5j-mercury-22.01.8`
works outside `nix develop`; `x85sr9yfr9r7p4pxjrm69fh4b8zxxndl-mercury-22.01.8`
(the debug-grade build) does not.

---

### `pragma memo` silently ignored in parallel grade

**Symptom:** Code using `pragma memo` compiles with a warning but memo has no effect.

**Cause:** Tabling (`pragma memo`) is incompatible with the parallel grade
(`asm_fast.par.gc.stseg`). The compiler does not error — it silently drops the pragma.

**Fix:** Either use the sequential grade for tabling, or accept that memo is a no-op
and demonstrate the concept differently.

---

## 2. Module imports — cryptic error messages

### `undefined symbol '[|]'/2` — missing `import_module list`

**Symptom:** Error on a line that uses `[s(X), i(Y)]` (a format argument list) or any
list literal.

**Cause:** List syntax (`[|]`, `[]`) lives in the `list` module. Without
`import_module list`, these symbols are undefined. The error message names the
constructor, not the module.

**Fix:** Add `:- import_module list.` The same applies to `io.format` calls — the
format argument list `[s(X), i(N)]` requires `list`.

---

### `undefined type 'char'/0` — missing `import_module char`

**Cause:** The `char` type is not automatically available. Import it explicitly.

---

### `undefined type 'bool'/0` — missing `import_module bool`

**Cause:** Same pattern. `bool`, `char`, `float`, `int`, `string` all require explicit
imports despite being primitive-feeling types.

---

### `undefined symbol 'float.log'/1` — math functions are in `math`, not `float`

**Cause:** Logarithms, trig, etc. live in `import_module math`, not `float`. `float`
only has arithmetic, conversion, and basic comparison.

---

### `undefined symbol 'i'/1` in `io.format` — missing `import_module string`

**Symptom:** `io.format("...", [i(N)], !IO)` fails with "undefined symbol `i'/1`,
that symbol is defined in module `string`."

**Cause:** The format specifier constructors (`i/1`, `s/1`, `f/1`, `c/1`) are
constructors of the `poly_type` type, which lives in the `string` module. Even if
the rest of the code uses no string functions, any `io.format` call with a format
argument list requires `import_module string`.

This appears particularly when a module uses no string operations and relies solely
on `io.format` — the dependency on `string` is not obvious.

**Fix:** Add `:- import_module string.` to the implementation section.

**Extra trap:** A file can compile successfully in a directory with a pre-built
`Mercury/` subdirectory (because the cached `.int` files satisfy the dependency
transitively) but fail from scratch in a clean directory. Always compile from a
fresh directory when verifying a file is self-contained.

---

## 3. Determinism system

### `cc_multi` propagates up the entire call chain

**Symptom:** Declaring a predicate `det` fails because it calls `thread.spawn`, which
is `cc_multi`. Fixing the declaration to `cc_multi` then breaks `main` (which is
declared `det`).

**Rule:** Any predicate that calls a `cc_multi` predicate must itself be declared
`cc_multi`. This propagates all the way to `main` if needed. Mercury allows `main` to
be declared `cc_multi`.

**Fix:** Change the declaration chain: calling pred → `cc_multi`; `main` → `cc_multi`.

---

### Semidet predicate with `io::di, io::uo` is a compile error

**Symptom:** Declaring `pred(int::in, io::di, io::uo) is semidet` and having the
predicate fail in some cases.

**Error:** "invalid determinism for a predicate with I/O state."

**Cause:** If a `semidet` predicate fails, the `io` token is never consumed — the
I/O state disappears. Any predicate that threads I/O state must be at least `det`.

**Fix:** Change to `det` and use if-then-else to handle the non-printing case
explicitly (e.g., `true` as the else branch).

---

### Multi-clause predicates with overlapping guards → `nondet`, not `det`

**Symptom:** Two clauses that are not mutually exclusive (both can match the same
input) are declared `det` but Mercury infers `nondet`.

**Example:**
```mercury
:- pred categorize(int::in, string::out) is det.  % WRONG
categorize(N, Cat) :- N >= 0, Cat = "non-negative".
categorize(N, Cat) :- N =< 0, Cat = "non-positive".
```
For `N = 0`, both clauses match → `nondet`.

**Fix:** Use a single if-then-else chain. Mercury cannot statically verify that
arithmetic guards are mutually exclusive.

---

### DCG multi-clause rules always infer `multi` or `nondet`

**Cause:** Multi-clause DCG rules behave like multi-clause predicates: if more than
one clause can match a given input, the determinism is `nondet` or `multi`. Mercury
does not infer `det` for multi-clause DCG rules even if the patterns look exclusive.

**Fix:** Rewrite multi-clause DCG rules as single-clause rules using if-then-else
inside the body.

---

### `cc_multi` (via thread.spawn) inferred as `multi`, not `cc_multi`

**Symptom:** Declaring a predicate `cc_multi` that calls `thread.spawn`. Mercury
infers `multi` (not `cc_multi`) and reports a determinism mismatch.

**Cause:** `thread.spawn` is `cc_multi`. A predicate calling it is inferred as `multi`
(the "requires all solutions" version), not `cc_multi`. The fix is to declare the
calling predicate as `cc_multi`.

---

### `list.member` is `nondet`, not `cc_nondet`

**Cause:** `list.member` is genuinely nondeterministic — it generates all members.
It is not `cc_nondet`. Using it to demonstrate a `cc_multi`/`cc_nondet` error
produces a plain "inferred nondet" error instead of the cc-specific error.

To demonstrate a `cc_multi` propagation error, use `thread.spawn` (which is genuinely
`cc_multi`).

---

### `parallel conjunct may fail` — `&` requires `det` sub-goals

**Error:** "parallel conjunct may fail. The current implementation supports only
single-solution non-failing parallel conjunctions."

**Cause:** `&` (parallel conjunction) requires both sub-goals to be `det`. A `semidet`
sub-goal may fail — there's no recovery path in the parallel context.

**Fix:** Make both sub-goals `det`. Move conditional logic outside the `&`.

---

## 4. Mode system

### Mercury reorders conjuncts — "free variable" bugs can be silently fixed

**Symptom:** Writing code with a variable used before it's bound (intending a mode
error for a koan), but the code compiles cleanly because Mercury reordered the goals.

**Rule:** Mercury's mode analysis reorders conjuncts to satisfy modes. If goal B
produces a variable that goal A needs, Mercury will run B before A automatically.
This is a feature, not a bug — but it means naive "use before bind" examples don't
produce errors.

**To trigger a genuine free variable error:** the variable must be bound in only one
branch of an if-then-else (not bound in all branches), or must never be bound at all
within the reachable goals.

---

### Unique (`di`) values consumed by `in` mode — no error

**Symptom:** Passing an `array_di` value to `array.set` (consuming it), then passing
the same variable to a predicate taking `array(T)::in`. Expected a uniqueness error;
code compiles cleanly.

**Rule:** Once a unique value is consumed via `di`, its memory remains valid for
read-only access. Mercury does not prevent reading a "spent" unique value via `in`
mode — it only prevents creating aliases (two simultaneous `di` references).

**The actual uniqueness error** (aliasing) occurs when you pass the same `di` value
to two separate destructive operations in the same clause.

---

### `uo` (unique output) must be produced in every branch

**Error:** "mode mismatch in if-then-else. The variable `A' is ground in some branches
but not others."

**Cause:** A predicate declaring `array(T)::array_uo` as output must initialize
the array in every execution path. Skipping initialization in one branch leaves
the variable `free`, violating the `uo` mode.

**Fix:** Initialize in every branch — even a fallback `array.init(0, default, A)`.

---

### Existential type construction fails from clause heads in Mercury 22

**Symptom:** Attempting to construct a value of an existential type at a call site:

```mercury
:- type plugin ---> some [T] plugin(T) => formatter(T).

mk_upper = plugin(upper).  % ERROR
```

produces:

```
type error in unification of argument and constant `upper'.
argument has type `(some [T] T)',
constant `upper' has type `plugins.upper'.
```

**Cause:** Mercury 22.01 represents the inner argument of an existentially
quantified constructor as `(some [T] T)` internally. From regular clause heads
(both function result positions and predicate head positions), the type checker
refuses to unify a concrete type with this existential type. The "packing" step —
wrapping a concrete value into an existential — is not available from normal
clause positions in this version.

Deconstruction (`plugin(X)` in a clause head for pattern matching) works fine
and brings T back into scope with its constraint. Only construction is affected.

**Workaround:** Replace the existential type with a record storing behavior as
first-class function closures. This achieves the same open-world extensibility:

```mercury
:- type plugin ---> plugin(
    pname  :: string,
    papply :: func(string) = string
).
mk_upper = plugin("upper", string.to_upper).
mk_repeat(N) = plugin("repeat", func(S) = repeat_str(N, S)).
```

New plugins are added without touching the core system — the closure captures the
plugin-specific data. The runtime cost (one closure allocation per plugin, one
indirect call) is equivalent to the existential+dictionary approach.

**Where discovered:** `puzzles/advanced/06-plugin-architecture/solution/plugins.m`

---

## 5. Type system

### `=` is a goal in Mercury, not an expression

**Symptom:** Writing `bool_val(VA = VB)` in a function body — intending to produce
`bool_val(yes)` if `VA` equals `VB`.

**Error:** "the language construct `='/2 should be used as a goal, not as an
expression."

**Cause:** In Mercury, `=` is unification (a goal/predicate), not an equality test
that returns a bool. It cannot appear inside a functor application as an expression.

**Fix:**
```mercury
( VA = VB -> Result = bool_val(yes) ; Result = bool_val(no) )
```

---

### Phantom type tags need a dummy constructor

**Symptom:** `:- type metres.` compiles but then gives "abstract declaration has no
corresponding definition."

**Cause:** In Mercury, `:- type metres.` declares an *abstract* type (no definition
visible in this module). It does not create an empty type. To create a concrete type
with no data, you must give it at least one constructor.

**Fix:**
```mercury
:- type metres ---> metres_unit.
```
The constructor is never called — it exists only to satisfy Mercury's requirement.

---

### Multi-clause function with pattern matching inside a clause body → `semidet`

**Symptom:** A function clause that pattern-matches on the result of another call
in the body is inferred `semidet`, not `det`.

**Example:**
```mercury
eval(add_e(A, B)) = int_val(NA + NB) :-
    eval(A) = int_val(NA),   % can fail if eval(A) returns bool_val(...)
    eval(B) = int_val(NB).
```
The unification `eval(A) = int_val(NA)` can fail → clause is `semidet`.

**Fix:** Use if-then-else with a fallback:
```mercury
eval(add_e(A, B)) = Result :-
    ( eval(A) = int_val(NA), eval(B) = int_val(NB) ->
        Result = int_val(NA + NB)
    ;
        Result = int_val(0)   % ill-typed expression fallback
    ).
```

---

## 6. Standard library surprises

### `char.digit_to_int` does not exist — use `char.decimal_digit_to_int`

The predicate for converting a digit character to an int is
`char.decimal_digit_to_int/2`, not `char.digit_to_int/2`.

---

### `list.foldl` takes `pred(L, A, A)`, not `func(L, A) = A`

**Cause:** `list.foldl` is declared with a predicate argument, not a function
argument. Passing a function lambda fails with a type or mode error.

**Fix:** Use a predicate lambda:
```mercury
list.foldl(pred(X::in, Acc::in, Next::out) is det :- Next = Acc + X,
           List, 0, Sum)
```

---

### `char.decimal_digit_to_int` cannot bind in an if-then-else condition

**Symptom:** Writing `( char.decimal_digit_to_int(C, Digit) -> ... ; ... )` and then
using `Digit` in the then-branch gives a scope error.

**Cause:** In Mercury, variables bound inside the condition of an if-then-else are
not in scope in the then-branch (they are scoped to the condition only).

**Fix:** Restructure so the binding happens inside each branch separately, not in
the condition.

---

## 7. Mercury 22.01.8 parallel grade (`&`) backend bugs

These are confirmed compiler bugs in Mercury 22.01.8, not user errors. The
workarounds are required for code using `&` in the `asm_fast.par.gc.stseg` grade.

### Bug 1: if-then-else after `&` output crashes the backend

**Symptom:**
```
ll_backend.var_locn.actually_place_var/6: Unexpected: placing nondummy var N
which has no state
```

**Trigger:** Using a variable produced by `&` in an if-then-else condition in the
same clause body.

**Workaround:** Extract the `&` call into a named predicate. Never use `&`-produced
variables in if-then-else conditions in the same clause. Replace bool-valued checks
with a `check_eq(Name, Got, Expected, !IO)` pattern.

---

### Bug 2: ordering of predicates containing `&` matters

**Symptom:**
```
clobber_lval_in_var_state_map/6: Unexpected: empty state
```

**Trigger:** Multiple predicates that internally contain `&` called in a clause,
in an order different from their definition order.

**Workaround:** Call predicates containing `&` in *definition order* — the predicate
defined first in the source file must be called first in `main`.

---

### Bug 3: function calls in `&` conjuncts crash the backend

**Symptom:** The backend crashes during code generation.

**Trigger:** Using `= expr` (function call syntax) inside a `&` conjunct:
```mercury
( A = heavy_compute(500) & B = heavy_compute(600) )  % CRASHES
```

**Workaround:** Use predicate form (`out` argument) instead of function form:
```mercury
:- pred heavy_compute(int::in, int::out) is det.
( heavy_compute(500, A) & heavy_compute(600, B) )    % OK
```
Functions in `&` conjuncts reliably crash the 22.01.8 backend. Use predicates
exclusively in parallel conjunctions.
