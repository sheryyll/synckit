# TLA+ Formal Verification for SyncKit

This directory contains formal specifications of SyncKit's core algorithms.

## Files

- **lww_merge.tla** - Last-Write-Wins merge algorithm specification
- **vector_clock.tla** - Vector clock causality tracking specification  
- **convergence.tla** - Strong Eventual Consistency proof
- **\*.cfg** - Model configuration files (defines constants and properties to check)

## Quick Start: Running TLC Model Checker

### Prerequisites

1. Download TLA+ Tools:
   ```
   https://github.com/tlaplus/tlaplus/releases/download/v1.8.0/tla2tools.jar
   ```
   Save it to this directory or somewhere accessible.

2. Ensure Java is installed:
   ```powershell
   java -version  # Should show Java 11 or higher
   ```

### Running the Verification

**Option 1: Run all checks (recommended)**
```powershell
cd C:\Users\user\synckit\protocol\tla
.\run-all-checks.ps1
```

**Option 2: Run individual checks**
```powershell
# Check LWW merge algorithm
java -jar tla2tools.jar -workers auto lww_merge.tla

# Check vector clock properties
java -jar tla2tools.jar -workers auto vector_clock.tla

# Check convergence proof (most important!)
java -jar tla2tools.jar -workers auto convergence.tla
```

### Expected Output

If everything passes, you'll see:
```
Model checking completed. No error has been found.
  Estimates of the probability that TLC did not check all reachable states
  because two distinct states had the same fingerprint:
  calculated (optimistic):  val = 8.0E-18
...states generated, X distinct states found, 0 states left on queue.
```

If TLC finds a bug, it will show:
```
Error: Invariant Convergence is violated.
The behavior up to this point is:
State 1: ...
State 2: ...
```

### What Each Check Verifies

#### lww_merge.tla
- ✅ **Convergence**: All replicas reach same state  
- ✅ **Determinism**: Same inputs = same outputs
- ✅ **Monotonicity**: Timestamps never decrease
- ✅ **Idempotence**: Duplicate operations have no effect

**Runtime:** ~30 seconds  
**State space:** ~10,000 states

#### vector_clock.tla  
- ✅ **CausalityPreserved**: Causality tracking works correctly
- ✅ **Transitivity**: Happens-before is transitive
- ✅ **Monotonicity**: Clocks only increase
- ✅ **ConcurrentDetection**: Concurrent ops detected correctly
- ✅ **MergeCorrectness**: Clock merging preserves causality

**Runtime:** ~45 seconds  
**State space:** ~20,000 states

#### convergence.tla
- ✅ **StrongEventualConsistency**: THE key property! All replicas converge
- ✅ **OrderIndependence**: Merge order doesn't matter
- ✅ **NoDataLoss**: All operations affect final state
- ✅ **MonotonicConvergence**: Progress toward convergence
- ✅ **ConflictFree**: Concurrent ops merge automatically

**Runtime:** ~2-5 minutes  
**State space:** ~50,000-100,000 states

## Troubleshooting

### "Out of memory" error
Increase Java heap size:
```powershell
java -Xmx4G -jar tla2tools.jar -workers auto convergence.tla
```

### TLC runs forever
The state space might be too large. Reduce constants in .cfg files:
- Change `MaxOperations = 5` to `3`
- Change `MaxTimestamp = 3` to `2`

### "Property violated" error
**This is good!** TLC found a bug in our algorithm design. Read the error trace carefully - it shows the exact sequence of operations that breaks the property.

## Interpreting Results

### ✅ All checks pass
**Congratulations!** You have **mathematical proof** that:
1. Your LWW merge algorithm is correct
2. Vector clocks work properly
3. Strong Eventual Consistency is guaranteed

You can now implement the Rust code with confidence!

### ❌ A check fails
TLC provides a **counterexample trace** showing exactly how to break the property. Example:

```
Error: Invariant Convergence is violated.
State 1: Client1 writes field1="v1" at timestamp=2
State 2: Client2 writes field1="v2" at timestamp=2  
State 3: Client1 receives Client2's write → field1="v2"
State 4: Client2 receives Client1's write → field1="v1"
Result: NOT CONVERGED! (This shouldn't be possible)
```

This tells you:
1. What sequence of operations causes the bug
2. What state each replica is in
3. Why convergence fails

You then fix the algorithm and re-run TLC!

## Advanced: Increasing Verification Depth

For more thorough verification, increase the bounds:

```cfg
\* convergence.cfg
CONSTANTS
    Clients = {c1, c2, c3, c4}  # 3 → 4 clients
    MaxOperations = 10          # 5 → 10 operations
    Fields = {f1, f2, f3}       # 2 → 3 fields
```

**Warning:** This can increase runtime from minutes to hours!

## Why This Matters

Companies like AWS, Microsoft Azure, and MongoDB use TLA+ for exactly this reason:

> "Finding bugs in 5 minutes with TLA+ vs. 5 days debugging production = priceless"  
> — Every distributed systems engineer

The 30-45 minutes spent on formal verification will save you **days or weeks** of debugging subtle race conditions in Rust code.

---

**Next Step:** Once all checks pass, proceed to Phase 2 (Rust implementation) with confidence! 🚀
