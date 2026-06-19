# Advanced

Topics that are genuinely niche but matter in practice: FFI, solver types, RTTI,
memoization, and association-list environments. Each is self-contained; work through
them in order before tackling the advanced puzzles.

| Kata | Topic |
|---|---|
| `01-ffi-depth/` | All four FFI pragmas: `foreign_decl`, `foreign_type`, `foreign_proc`, `foreign_export` |
| `02-solver-types/` | Reference kata — solver type declaration, `any` inst, `.tr` grade (no working build) |
| `03-rtti/` | `deconstruct.deconstruct/5`, generic pretty-printer, when RTTI is appropriate |
| `04-pragma-memo/` | `pragma memo` for deterministic predicates; manual memoization via state-threaded map |
| `05-assoc-list-env/` | Association lists as environments: lookup, shadowing, deref chains; the idiom the meta-interpreter uses |
| `06-abstract-module/` | Abstract type declaration; information hiding; `use_module` vs `import_module`; swapping implementations without touching clients |
| `07-ffi-pragma-attrs/` | `will_not_call_mercury`, `promise_pure`, `thread_safe` — what each attribute does and the cost of omitting it |

**Not in the Mercury tutorial.**
