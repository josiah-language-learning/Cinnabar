# Crypto-arithmetic solution notes

## Performance: constraint ordering matters

The naive version generates all 10! / 2! = 1,814,400 distinct assignments and checks.
Adding `\=` constraints incrementally prunes branches early.

**Key optimization:** apply the uniqueness constraints *as each variable is generated*,
not at the end. The order in the solution (`E \= S` immediately after generating `E`)
means branches with duplicate values are pruned before generating further variables.

**Further optimization:** apply the arithmetic constraint partially as variables become
available. For example, check the units digit immediately:

```mercury
D + E = Y + 10 * Carry1,   % units column, before generating more variables
```

This requires restructuring the generator around the carry-chain, which is more complex
but dramatically faster for large alphametics.

## The expected solution

SEND + MORE = MONEY → S=9, E=5, N=6, D=7, M=1, O=0, R=8, Y=2

Check: 9567 + 1085 = 10652 ✓
