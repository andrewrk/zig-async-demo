# Factorial

This example contributed by @bhansconnect with the idiomatic version added
by @andrewrk.

This is a version of factorial and parallel factorial in Zig and Go.
There is a linear and parallel version of both tests just to show the gains
from running in parallel. Finally, there is a Zig version that depends on
[gmp](https://gmplib.org/) and one that depends on
[std.math.big.Int](https://ziglang.org/documentation/master/std/#std;math.big.Int)
(pure Zig).

In this README I have experimented with the x86_64-linux-gnu target.
This laptop has a Intel(R) Core(TM) i9-9980HK CPU @ 2.40GHz.

 * fact-linear.go - non-parallel version 
 * fact-linear.zig - ported to zig, using `std.math.big.Int`. Not quite
   pure zig because it uses libc memory allocator. Zig std lib has no
   general purpose memory allocator yet.
 * fact-linear-gmp.zig - using gmp instead of `std.math.big.Int`.
 * fact-channel.go - parallel version using goroutines & channels
 * fact-channel.zig - ported directly to zig, using `std.math.big.Int`.
   Again, not quite pure zig because it uses libc memory allocator.
 * fact-channel-gmp.zig - using gmp instead of `std.math.big.Int`.
 * fact-await.zig - written in idiomatic zig using async/await. Note how it
   looks a lot closer to fact-linear.zig than fact-channel.zig.
 * fact-await-gmp.zig - using gmp instead of `std.math.big.Int`.

## Software Versions

 * go version go1.4-bootstrap-20161024 linux/amd64
 * zig 0.5.0+ce70a9be

## Output

Printing is omitted because it is super slow and really skews the results.
Go's BigInt prints so horridly slow for some reason (even when just printing to
`/dev/null`).

Note from @andrewrk: I think the printing will have to be included to make this
comparison more sound; technically without some kind of output that depends on
the input, the compiler is allowed to delete all the code, since the program
has no side effects.

## Binary Size

Go does not have a configurable build mode, so, which Zig build mode should
we choose that is closest to Go's? Typically this would be
[ReleaseSafe](https://ziglang.org/documentation/master/#ReleaseSafe).
However, in this example we are doing number crunching. This code is likely
to be a bottleneck, and therefore to be well-tested and then have optimizations
enabled. This makes
[ReleaseFast](https://ziglang.org/documentation/master/#ReleaseFast) the most
fair build mode to choose.

```
go build fact-linear.go
zig build-exe fact-linear.zig --release-fast
zig build-exe fact-linear-gmp.zig --release-fast -lc -lgmp
go build fact-channel.go
zig build-exe fact-channel.zig --release-fast -lc
zig build-exe fact-channel-gmp.zig --release-fast -lc -lgmp
zig build-exe fact-await.zig --release-fast -lc
zig build-exe fact-await-gmp.zig --release-fast -lc -lgmp
```

 * fact-linear (Go) - 2.3 MiB (statically linked)
 * fact-linear (Zig) - 388 KiB (dynamically linked)
 * fact-linear-gmp (Zig) - 41 KiB (dynamically linked)
 * fact-channel (Go) - 2.3 MiB (statically linked)
 * fact-channel (Zig) - 574 KiB (dynamically linked)
 * fact-channel-gmp (Zig) - 229 KiB (dynamically linked)
 * fact-await (Zig) - 500 KiB (dynamically linked)
 * fact-await-gmp (Zig) - 143 KiB (dynamically linked)

## Compilation Speed

In this case it makes more sense to measure Zig's debug build mode:

```
zig build-exe fact-linear.zig
```

 * fact-linear.go - 0.11 seconds
 * fact-linear.zig - 0.51 seconds
 * fact-linear-gmp.zig - 0.62 seconds
 * fact-channel.go - 0.10 seconds
 * fact-channel.zig - 1.0 seconds
 * fact-channel-gmp.zig - 1.0 seconds
 * fact-await.zig - 1.0 seconds
 * fact-await-gmp.zig - 0.98 seconds


Go is certainly going to win on this comparison until Zig has a
non-LLVM backend. Here's a timing report from Zig with diagnostics
enabled. You can see most of the time is spent waiting for LLVM:

```
                Name       Start         End    Duration     Percent
          Initialize      0.0000      0.0005      0.0005      0.0004
   Semantic Analysis      0.0005      0.3264      0.3259      0.2422
     Code Generation      0.3264      0.4054      0.0790      0.0587
    LLVM Emit Output      0.4054      1.2898      0.8844      0.6572
  Build Dependencies      1.2898      1.3058      0.0160      0.0119
           LLVM Link      1.3058      1.3457      0.0400      0.0297
               Total      0.0000      1.3457      1.3457      1.0000
```


## Performance

 * fact-linear.go - 19.86 seconds
 * fact-linear.zig - 46.43 seconds
 * fact-linear-gmp.zig - 1.26 seconds
 * fact-channel.go - 20.2 seconds
 * fact-channel.zig - 23.6 seconds
 * fact-channel-gmp.zig - 0.4 seconds
 * fact-await.zig - 36.5 seconds
 * fact-await-gmp.zig - 2.0 seconds

The most important thing to note here is that the fastest performance was a
single-threaded implementation that linked gmp, which has high performance
big-integer multiplication. On the other hand, the API does not provide a way
to handle allocation failure, which may affect performance benchmarking.

The idiomatic implementation in Zig using async/await, I think could be
improved with changes to the event loop implementation. In the sieve/ directory
in this project there is a bit of analysis on why this is.

However, importantly, I want to show how close to the linear version the
async/await version is. In fact, you can make a single-line change, and it will
actually *become the linear version*. Watch this:

```diff
--- a/factorial/fact-await.zig
+++ b/factorial/fact-await.zig
@@ -2,8 +2,6 @@ const std = @import("std");
 const BigInt = std.math.big.Int;
 const allocator = std.heap.c_allocator;
 
-pub const io_mode = .evented;
 
 pub fn main() !void {
     try fact(3000000);
 }

--- a/factorial/fact-await-gmp.zig
+++ b/factorial/fact-await-gmp.zig
@@ -5,8 +5,6 @@ const c = @cImport({
     @cInclude("gmp.h");
 });
 
-pub const io_mode = .evented;
 
 pub fn main() !void {
     try fact(3000000);
 }
```

With this modification:

 * fact-await.zig - 47.9 seconds
 * fact-await-gmp.zig - 1.40 seconds

These programs end up generating near-identical code to fact-linear.zig and fact-linear-gmp.zig,
end up using only a single-thread of execution, and have roughly the same performance!

This means you can write code in Zig that expresses parallelism, which works in both evented I/O
and blocking programs.
