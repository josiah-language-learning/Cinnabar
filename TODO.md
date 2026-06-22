# TODO

Backlog derived from the 2026-06-22 quorum synthesis. Full reasoning:
[`REVIEWS-SYNTHESIS/SYNTHESIS.md`](REVIEWS-SYNTHESIS/SYNTHESIS.md).

**Model-fit:** `[Opus]` Mercury semantics; `[Sonnet]` mechanical/editorial;
`[User]` environment/infra; `[any]` general work.

**Effort:** `{low}` small edit; `{medium}` contained change plus verification;
`{high}` non-local work requiring compiler validation.

## P0 — restore trust

- [ ] `[any] {low}` **Restore one canonical CI executable.** Restore `ci.sh`, or make an intentional rename and update `Agents.md`, the workflow, and every documented command atomically.
Verify the documented command works from the current worktree.

- [ ] `[Opus] {medium}` **Regenerate eight drifted koan `.err` snapshots** with the pinned compiler: advanced/01-ffi, concurrency/01-parallel, foundations/01-maybe, foundations/05-
exceptions, foundations/06-file-io, foundations/12-map-io-capture, mode-system/03-higher-order-inst, and type-system/01-adt. Preserve intentional failure.

- [ ] `[User] {high}` **Resolve README-required grade availability.** Provision, or clearly mark unavailable, the serial, profiling, and non-parallel grades required by packrat,
concurrent-IO, profiling, graph, and memoized-search workflows.

## P1 — navigation and first contact

- [ ] `[Sonnet] {low}` **Fix four dead type-system koan prerequisites.** Change three `03-typeclasses` links to `04-type-classes`; change `04-phantom-types` to `09-phantom-types` in `08-
phantom-mismatch`. Add a local-path-reference CI check.

- [ ] `[Sonnet] {low}` **Align foundations titles and headings.** Correct `05-map` and `06-set` title numbers, then standardize inline `**Concept:**` sections to `## Concept`.

- [ ] `[Sonnet] {low}` **Complete Bridge 10 framing.** Add “Why Mercury,” remove its self-stale solution note, and state lost-work semantics explicitly.

- [ ] `[Sonnet] {medium}` **Add duration bands.** Start with `short`, `medium`, and `long` in indexes and exercise READMEs.

## P2 — verification and transfer

- [ ] `[Opus] {high}` **Semantically audit bridge solution snippets.** The short-interface gate cannot prove types, modes, or determinism. Compile representative snippets as self-
contained modules with stubs, prioritizing determinism and concurrency bridges.

- [ ] `[Sonnet] {medium}` **Add retrieval prompts and worked examples.** Add end-of-track mixed review prompts and one annotated solution per track; name the reactivation predict-verify
transition in `START-HERE.md`.

- [ ] `[any] {medium}` **Add a TOC and hygiene checks.** Add a `COMPILER-LESSONS.md` TOC, supported compiler warnings, shell syntax checks, and local-link/path validation.

## P3 — selective expansion

- [ ] `[Opus] {high}` **Add package/build-system practice.** Cover interfaces, dependency direction, multi-module `mmc --make`, and refactoring.

- [ ] `[Sonnet] {medium}` **Add a standard-library decision guide.** Cover `cord`, `foldl2`, `map_foldl`, `use_module` versus `import_module`, and output formatting.

- [ ] `[Sonnet] {medium}` **Add limited “Paradigm Note” callouts** where comparison materially clarifies a Mercury invariant.

## Advisory

- [ ] `[any]` **Do not add generic kata test scripts.** Every kata already has `runtests`; evaluate test quality instead.

- [ ] `[any]` **Do not replace `empty(_, _, _) :- fail.`** Compiler verification shows it is required for the declared mode.

