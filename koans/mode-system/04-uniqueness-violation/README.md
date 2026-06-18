# Koan: unique state cannot be aliased

## Prerequisites
- `katas/mode-system/03-uniqueness-deep`
- `katas/mode-system/01-insts-and-modes`

The `!IO` state thread is **unique** — consumed and produced exactly once per goal. This predicate tries to save the IO state and restore it after a write:

```mercury
Saved = !.IO,
io.write_string("before\n", !IO),
!:IO = Saved.   % ← compiler rejects this
```

Compile it:

```
mmc --make uniqueness_koan
```

---

`Saved = !.IO` creates an alias: both `Saved` and the current IO token name the same value. Mercury's uniqueness checker tracks that the original token is consumed by `io.write_string`. After that point, `Saved` is a reference to a value that no longer exists as unique — assigning it back via `!:IO = Saved` violates the guarantee that each unique value is used exactly once.

Unique types exist precisely to prevent this. If IO state could be saved and restored, you could replay IO effects, breaking the semantics of the IO monad that Mercury's purity system depends on.

The fix: remove the save/restore and sequence the goals directly.

---

## What to observe

The error mentions "unique" or "aliasing" and points to the assignment `!:IO = Saved`.
Notice that `Saved = !.IO` itself compiles — the alias is created silently. The error
fires when Mercury detects that a consumed unique value is being put back into use.

---

## Your task

Remove the save/restore. If the intent was to undo a write, that is not possible — IO
in Mercury is intentionally irreversible. Sequence the goals in the order you want
them to execute.
