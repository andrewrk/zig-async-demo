# Sieve of Eratosthenes

 * sieve.go - [provided by shivammamgain](https://twitter.com/shivammamgain/status/1189766900500201473)
 * sieve.zig - my direct port to zig. 

Note: this would not be the recommended way to implement a
concurrent prime sieve in Zig; this implementation is intended
to serve as a direct port of the reference Go code.

In this README I have experimented with the x86_64-linux-gnu target.
This laptop has a Intel(R) Core(TM) i9-9980HK CPU @ 2.40GHz.

## Versions

 * go version go1.13.3 linux/amd64
 * zig 0.5.0+9bc4f8ea

## Output

Both programs output the same:

```
2
3
5
7
11
13
17
19
23
29
```

## Binary Size

Go does not have a configurable build mode, so, which Zig build mode should
we choose that is closest to Go's? This would be
[ReleaseSafe](https://ziglang.org/documentation/master/#ReleaseSafe).

```
go build sieve.go
zig build-exe sieve.zig --release-safe
```

 * sieve (Go) - 2.0 MiB
 * sieve (Zig) - 982 KiB

## Compilation Speed

In this case it makes more sense to measure Zig's debug build mode:

```
zig build-exe sieve.zig
```

 * sieve.go - 0.13 seconds
 * sieve.zig - 0.83 seconds

Go is certainly going to win on this comparison until Zig has a
non-LLVM backend. Here's a timing report from Zig with diagnostics
enabled. You can see most of the time is spent waiting for LLVM:

```
          Initialize      0.0000      0.0005      0.0005      0.0004
   Semantic Analysis      0.0005      0.3084      0.3080      0.2564
     Code Generation      0.3084      0.3888      0.0803      0.0669
    LLVM Emit Output      0.3888      1.1706      0.7818      0.6510
  Build Dependencies      1.1706      1.1712      0.0006      0.0005
           LLVM Link      1.1712      1.2009      0.0297      0.0247
               Total      0.0000      1.2009      1.2009      1.0000
```

## strace

<details>
<summary>Go strace</summary>
<br>
<pre>
execve("./sieve-go", ["./sieve-go"], 0x7ffdc1626e48 /* 125 vars */) = 0
arch_prctl(ARCH_SET_FS, 0x5610f0)       = 0
sched_getaffinity(0, 8192, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]) = 48
openat(AT_FDCWD, "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size", O_RDONLY) = 3
read(3, "2097152\n", 20)                = 8
close(3)                                = 0
mmap(NULL, 262144, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0f68fc4000
mmap(0xc000000000, 67108864, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xc000000000
mmap(0xc000000000, 67108864, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xc000000000
mmap(NULL, 33554432, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0f66fc4000
mmap(NULL, 2164736, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0f66db3000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0f66da3000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0f66d93000
rt_sigprocmask(SIG_SETMASK, NULL, [], 8) = 0
sigaltstack(NULL, {ss_sp=NULL, ss_flags=SS_DISABLE, ss_size=0}) = 0
sigaltstack({ss_sp=0xc000002000, ss_flags=0, ss_size=32768}, NULL) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
gettid()                                = 29797
rt_sigaction(SIGHUP, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGHUP, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGINT, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGINT, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGQUIT, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGQUIT, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGILL, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGILL, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGTRAP, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGTRAP, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGABRT, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGABRT, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGBUS, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGBUS, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGFPE, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGFPE, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGUSR1, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGUSR1, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGSEGV, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGSEGV, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGUSR2, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGUSR2, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGPIPE, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGPIPE, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGALRM, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGALRM, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGTERM, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGTERM, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGSTKFLT, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGSTKFLT, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGCHLD, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGCHLD, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGURG, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGURG, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGXCPU, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGXCPU, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGXFSZ, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGXFSZ, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGVTALRM, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGVTALRM, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGPROF, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGPROF, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGWINCH, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGWINCH, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGIO, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGIO, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGPWR, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGPWR, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGSYS, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGSYS, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRTMIN, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_1, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_2, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_2, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_3, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_3, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_4, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_4, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_5, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_5, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_6, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_6, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_7, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_7, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_8, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_8, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_9, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_9, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_10, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_10, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_11, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_11, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_12, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_12, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_13, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_13, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_14, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_14, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_15, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_15, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_16, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_16, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_17, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_17, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_18, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_18, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_19, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_19, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_20, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_20, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_21, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_21, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_22, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_22, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_23, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_23, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_24, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_24, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_25, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_25, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_26, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_26, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_27, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_27, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_28, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_28, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_29, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_29, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_30, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_30, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_31, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_31, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigaction(SIGRT_32, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGRT_32, {sa_handler=0x4551f0, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x455320}, NULL, 8) = 0
rt_sigprocmask(SIG_SETMASK, ~[], [], 8) = 0
clone(child_stack=0xc000088000, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM) = 29798
strace: Process 29798 attached
[pid 29797] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 29798] gettid( <unfinished ...>
[pid 29797] rt_sigprocmask(SIG_SETMASK, ~[], [], 8) = 0
[pid 29797] clone(child_stack=0xc00008a000, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM <unfinished ...>
[pid 29798] <... gettid resumed>)       = 29798
[pid 29797] <... clone resumed>)        = 29799
[pid 29797] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
strace: Process 29799 attached
[pid 29798] arch_prctl(ARCH_SET_FS, 0xc000078090 <unfinished ...>
[pid 29797] rt_sigprocmask(SIG_SETMASK, ~[],  <unfinished ...>
[pid 29799] gettid( <unfinished ...>
[pid 29797] <... rt_sigprocmask resumed>[], 8) = 0
[pid 29797] clone(child_stack=0xc000084000, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM <unfinished ...>
[pid 29798] <... arch_prctl resumed>)   = 0
[pid 29799] <... gettid resumed>)       = 29799
[pid 29797] <... clone resumed>)        = 29800
[pid 29798] sigaltstack(NULL,  <unfinished ...>
[pid 29797] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 29799] arch_prctl(ARCH_SET_FS, 0xc000078410strace: Process 29800 attached
 <unfinished ...>
[pid 29797] <... rt_sigprocmask resumed>NULL, 8) = 0
[pid 29798] <... sigaltstack resumed>{ss_sp=NULL, ss_flags=SS_DISABLE, ss_size=0}) = 0
[pid 29799] <... arch_prctl resumed>)   = 0
[pid 29797] futex(0x5611a8, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29798] sigaltstack({ss_sp=0xc00007a000, ss_flags=0, ss_size=32768}, NULL) = 0
[pid 29798] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 29800] gettid( <unfinished ...>
[pid 29799] sigaltstack(NULL,  <unfinished ...>
[pid 29798] <... rt_sigprocmask resumed>NULL, 8) = 0
[pid 29800] <... gettid resumed>)       = 29800
[pid 29799] <... sigaltstack resumed>{ss_sp=NULL, ss_flags=SS_DISABLE, ss_size=0}) = 0
[pid 29798] gettid( <unfinished ...>
[pid 29799] sigaltstack({ss_sp=0xc00008a000, ss_flags=0, ss_size=32768},  <unfinished ...>
[pid 29798] <... gettid resumed>)       = 29798
[pid 29799] <... sigaltstack resumed>NULL) = 0
[pid 29798] nanosleep({tv_sec=0, tv_nsec=20000},  <unfinished ...>
[pid 29800] arch_prctl(ARCH_SET_FS, 0xc000078790 <unfinished ...>
[pid 29799] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 29800] <... arch_prctl resumed>)   = 0
[pid 29799] <... rt_sigprocmask resumed>NULL, 8) = 0
[pid 29800] sigaltstack(NULL,  <unfinished ...>
[pid 29799] gettid()                    = 29799
[pid 29799] rt_sigprocmask(SIG_SETMASK, ~[],  <unfinished ...>
[pid 29798] <... nanosleep resumed>NULL) = 0
[pid 29800] <... sigaltstack resumed>{ss_sp=NULL, ss_flags=SS_DISABLE, ss_size=0}) = 0
[pid 29799] <... rt_sigprocmask resumed>[], 8) = 0
[pid 29800] sigaltstack({ss_sp=0xc000094000, ss_flags=0, ss_size=32768},  <unfinished ...>
[pid 29798] nanosleep({tv_sec=0, tv_nsec=20000},  <unfinished ...>
[pid 29800] <... sigaltstack resumed>NULL) = 0
[pid 29799] clone(child_stack=0xc0000ae000, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM <unfinished ...>
[pid 29800] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
strace: Process 29801 attached
[pid 29800] gettid( <unfinished ...>
[pid 29799] <... clone resumed>)        = 29801
[pid 29798] <... nanosleep resumed>NULL) = 0
[pid 29800] <... gettid resumed>)       = 29800
[pid 29799] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 29798] nanosleep({tv_sec=0, tv_nsec=20000},  <unfinished ...>
[pid 29800] futex(0x5611a8, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 29799] <... rt_sigprocmask resumed>NULL, 8) = 0
[pid 29797] <... futex resumed>)        = 0
[pid 29801] gettid( <unfinished ...>
[pid 29800] <... futex resumed>)        = 1
[pid 29799] futex(0xc0000784c8, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29800] futex(0xc000078848, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29801] <... gettid resumed>)       = 29801
[pid 29798] <... nanosleep resumed>NULL) = 0
[pid 29798] nanosleep({tv_sec=0, tv_nsec=20000},  <unfinished ...>
[pid 29801] arch_prctl(ARCH_SET_FS, 0xc00009c090 <unfinished ...>
[pid 29797] readlinkat(AT_FDCWD, "/proc/self/exe",  <unfinished ...>
[pid 29801] <... arch_prctl resumed>)   = 0
[pid 29798] <... nanosleep resumed>NULL) = 0
[pid 29797] <... readlinkat resumed>"/home/andy/dev/zig-async-demo/si"..., 128) = 44
[pid 29798] nanosleep({tv_sec=0, tv_nsec=20000},  <unfinished ...>
[pid 29797] fcntl(0, F_GETFL)           = 0x2 (flags O_RDWR)
[pid 29801] sigaltstack(NULL,  <unfinished ...>
[pid 29797] mmap(NULL, 262144, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0f66d53000
[pid 29797] fcntl(1, F_GETFL <unfinished ...>
[pid 29798] <... nanosleep resumed>NULL) = 0
[pid 29797] <... fcntl resumed>)        = 0x2 (flags O_RDWR)
[pid 29801] <... sigaltstack resumed>{ss_sp=NULL, ss_flags=SS_DISABLE, ss_size=0}) = 0
[pid 29797] fcntl(2, F_GETFL <unfinished ...>
[pid 29801] sigaltstack({ss_sp=0xc0000a0000, ss_flags=0, ss_size=32768},  <unfinished ...>
[pid 29797] <... fcntl resumed>)        = 0x2 (flags O_RDWR)
[pid 29801] <... sigaltstack resumed>NULL) = 0
[pid 29801] rt_sigprocmask(SIG_SETMASK, [],  <unfinished ...>
[pid 29798] nanosleep({tv_sec=0, tv_nsec=20000},  <unfinished ...>
[pid 29797] write(1, "2\n", 2 <unfinished ...>
2
[pid 29801] <... rt_sigprocmask resumed>NULL, 8) = 0
[pid 29797] <... write resumed>)        = 2
[pid 29801] gettid( <unfinished ...>
[pid 29797] write(1, "3\n", 23
 <unfinished ...>
[pid 29801] <... gettid resumed>)       = 29801
[pid 29797] <... write resumed>)        = 2
[pid 29801] futex(0xc000078848, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 29797] write(1, "5\n", 25
 <unfinished ...>
[pid 29801] <... futex resumed>)        = 1
[pid 29800] <... futex resumed>)        = 0
[pid 29797] <... write resumed>)        = 2
[pid 29801] futex(0xc00009c148, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29800] futex(0xc000078848, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29797] futex(0xc000078848, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 29800] <... futex resumed>)        = -1 EAGAIN (Resource temporarily unavailable)
[pid 29797] <... futex resumed>)        = 0
[pid 29798] <... nanosleep resumed>NULL) = 0
[pid 29797] write(1, "7\n", 2 <unfinished ...>
7
[pid 29800] nanosleep({tv_sec=0, tv_nsec=3000},  <unfinished ...>
[pid 29797] <... write resumed>)        = 2
[pid 29798] nanosleep({tv_sec=0, tv_nsec=20000},  <unfinished ...>
[pid 29797] write(1, "11\n", 311
)         = 3
[pid 29797] write(1, "13\n", 313
)         = 3
[pid 29797] write(1, "17\n", 317
 <unfinished ...>
[pid 29800] <... nanosleep resumed>NULL) = 0
[pid 29797] <... write resumed>)        = 3
[pid 29800] futex(0xc00009c148, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 29797] futex(0x5611a8, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29801] <... futex resumed>)        = 0
[pid 29800] <... futex resumed>)        = 1
[pid 29798] <... nanosleep resumed>NULL) = 0
[pid 29801] futex(0xc00009c148, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29800] futex(0xc00009c148, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 29801] <... futex resumed>)        = -1 EAGAIN (Resource temporarily unavailable)
[pid 29798] nanosleep({tv_sec=0, tv_nsec=20000},  <unfinished ...>
[pid 29801] nanosleep({tv_sec=0, tv_nsec=3000},  <unfinished ...>
[pid 29800] <... futex resumed>)        = 0
[pid 29800] write(1, "19\n", 319
)         = 3
[pid 29800] write(1, "23\n", 3 <unfinished ...>
23
[pid 29801] <... nanosleep resumed>NULL) = 0
[pid 29800] <... write resumed>)        = 3
[pid 29798] <... nanosleep resumed>NULL) = 0
[pid 29801] futex(0x5611a8, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 29800] futex(0xc000078848, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29801] <... futex resumed>)        = 1
[pid 29797] <... futex resumed>)        = 0
[pid 29798] nanosleep({tv_sec=0, tv_nsec=20000},  <unfinished ...>
[pid 29797] futex(0xc000078848, FUTEX_WAKE_PRIVATE, 1) = 1
[pid 29801] write(1, "29\n", 3 <unfinished ...>
29
[pid 29800] <... futex resumed>)        = 0
[pid 29801] <... write resumed>)        = 3
[pid 29797] futex(0x5611a8, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29800] futex(0xc000078848, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>
[pid 29801] futex(0xc000078848, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 29800] <... futex resumed>)        = -1 EAGAIN (Resource temporarily unavailable)
[pid 29801] <... futex resumed>)        = 0
[pid 29798] <... nanosleep resumed>NULL) = 0
[pid 29801] exit_group(0 <unfinished ...>
[pid 29800] nanosleep({tv_sec=0, tv_nsec=3000},  <unfinished ...>
[pid 29801] <... exit_group resumed>)   = ?
[pid 29797] <... futex resumed>)        = ?
[pid 29800] <... nanosleep resumed> <unfinished ...>) = ?
[pid 29799] <... futex resumed>)        = ?
[pid 29801] +++ exited with 0 +++
[pid 29800] +++ exited with 0 +++
[pid 29798] +++ exited with 0 +++
[pid 29799] +++ exited with 0 +++
+++ exited with 0 +++
</pre>
</details>


<details>
<summary>Zig strace</summary>
<br>
<pre>
execve("./sieve-zig", ["./sieve-zig"], 0x7ffd88c45e98 /* 62 vars */) = 0
rt_sigaction(SIGSEGV, {sa_handler=0x25bff0, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART|SA_RESETHAND|SA_SIGINFO, sa_restorer=0x2075b0}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
sched_getaffinity(0, 128, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]) = 48
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d8933a000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d89339000
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 3
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 4
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 5
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 6
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 7
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 8
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 9
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 10
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 11
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 12
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 13
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 14
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 15
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 16
eventfd2(1, EFD_CLOEXEC|EFD_NONBLOCK)   = 17
epoll_create1(EPOLL_CLOEXEC)            = 18
eventfd2(0, EFD_CLOEXEC|EFD_NONBLOCK)   = 19
epoll_ctl(18, EPOLL_CTL_ADD, 19, {EPOLLIN, {u32=2519648, u64=2519648}}) = 0
mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d88337000
mprotect(0x7f2d88337000, 16785408, PROT_READ|PROT_WRITE) = 0
clone(child_stack=0x7f2d89337ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[31543], child_tidptr=0x7f2d89338000) = 31543
strace: Process 31543 attached
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d87335000
[pid 31542] mprotect(0x7f2d87335000, 16785408, PROT_READ|PROT_WRITE <unfinished ...>
[pid 31543] futex(0x2671d8, FUTEX_WAIT, 0, NULL <unfinished ...>
[pid 31542] <... mprotect resumed>)     = 0
[pid 31542] clone(child_stack=0x7f2d88335ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[31544], child_tidptr=0x7f2d88336000) = 31544
strace: Process 31544 attached
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 31544] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... mmap resumed>)         = 0x7f2d86333000
[pid 31542] mprotect(0x7f2d86333000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d87333ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 31545 attached
, parent_tid=[31545], child_tidptr=0x7f2d87334000) = 31545
[pid 31545] epoll_pwait(18,  <unfinished ...>
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d85331000
[pid 31542] mprotect(0x7f2d85331000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d86331ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[31546], child_tidptr=0x7f2d86332000) = 31546
strace: Process 31546 attached
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d8432f000
[pid 31546] epoll_pwait(18,  <unfinished ...>
[pid 31542] mprotect(0x7f2d8432f000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d8532fff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[31547], child_tidptr=0x7f2d85330000) = 31547
strace: Process 31547 attached
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... mmap resumed>)         = 0x7f2d8332d000
[pid 31542] mprotect(0x7f2d8332d000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d8432dff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[31548], child_tidptr=0x7f2d8432e000) = 31548
strace: Process 31548 attached
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... mmap resumed>)         = 0x7f2d8232b000
[pid 31542] mprotect(0x7f2d8232b000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d8332bff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[31549], child_tidptr=0x7f2d8332c000) = 31549
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d81329000
[pid 31542] mprotect(0x7f2d81329000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d82329ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 31550 attached
, parent_tid=[31550], child_tidptr=0x7f2d8232a000) = 31550
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d80327000
[pid 31542] mprotect(0x7f2d80327000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d81327ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[31551], child_tidptr=0x7f2d81328000) = 31551
strace: Process 31551 attached
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d7f325000
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31542] mprotect(0x7f2d7f325000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d80325ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 31549 attached
 <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... clone resumed>, parent_tid=[31552], child_tidptr=0x7f2d80326000) = 31552
strace: Process 31552 attached
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d7e323000
[pid 31542] mprotect(0x7f2d7e323000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d7f323ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 31553 attached
, parent_tid=[31553], child_tidptr=0x7f2d7f324000) = 31553
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... mmap resumed>)         = 0x7f2d7d321000
[pid 31542] mprotect(0x7f2d7d321000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d7e321ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 31554 attached
, parent_tid=[31554], child_tidptr=0x7f2d7e322000) = 31554
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d7c31f000
[pid 31542] mprotect(0x7f2d7c31f000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d7d31fff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 31555 attached
, parent_tid=[31555], child_tidptr=0x7f2d7d320000) = 31555
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d7b31d000
[pid 31542] mprotect(0x7f2d7b31d000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d7c31dff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 31556 attached
, parent_tid=[31556], child_tidptr=0x7f2d7c31e000) = 31556
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d7a31b000
[pid 31542] mprotect(0x7f2d7a31b000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d7b31bff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[31557], child_tidptr=0x7f2d7b31c000) = 31557
strace: Process 31557 attached
[pid 31542] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2d79319000
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31542] mprotect(0x7f2d79319000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 31542] clone(child_stack=0x7f2d7a319ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[31558], child_tidptr=0x7f2d7a31a000) = 31558
strace: Process 31558 attached
[pid 31542] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... mmap resumed>)         = 0x7f2d79318000
[pid 31542] epoll_ctl(18, EPOLL_CTL_ADD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}}) = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_ADD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] write(2, "2", 12)            = 1
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31558] write(2, "\n", 1
)           = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}}) = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31542] write(2, "3", 1 <unfinished ...>
3[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] <... write resumed>)        = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31542] write(2, "\n", 1
 <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... write resumed>)        = 1
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_ctl(18, EPOLL_CTL_ADD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31554] write(2, "5", 15 <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... write resumed>)        = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31554] write(2, "\n", 1
 <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31554] <... write resumed>)        = 1
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31557] epoll_ctl(18, EPOLL_CTL_ADD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31556] write(2, "7", 1 <unfinished ...>
7[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31556] <... write resumed>)        = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31556] write(2, "\n", 1
 <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... write resumed>)        = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}}) = 0
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}}) = 0
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}}) = 0
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_ADD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] write(2, "11", 2 <unfinished ...>
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
11[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31552] <... write resumed>)        = 2
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31552] write(2, "\n", 1
 <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31552] <... write resumed>)        = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31555] write(2, "13", 2 <unfinished ...>
13[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] <... write resumed>)        = 2
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] write(2, "\n", 1 <unfinished ...>

[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] <... write resumed>)        = 1
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31552] write(2, "17", 217 <unfinished ...>
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31552] <... write resumed>)        = 2
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31552] write(2, "\n", 1 <unfinished ...>

[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31552] <... write resumed>)        = 1
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] write(2, "19", 219 <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31553] <... write resumed>)        = 2
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31553] write(2, "\n", 1 <unfinished ...>

[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] <... write resumed>)        = 1
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] epoll_ctl(18, EPOLL_CTL_ADD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31549] write(2, "23", 223 <unfinished ...>
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... write resumed>)        = 2
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31549] write(2, "\n", 1 <unfinished ...>

[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31549] <... write resumed>)        = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31557] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862216, u64=139833552118088}} <unfinished ...>
[pid 31556] epoll_ctl(18, EPOLL_CTL_ADD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862280, u64=139833552118152}} <unfinished ...>
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31557] <... epoll_ctl resumed>)    = 0
[pid 31556] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862280, u64=139833552118152}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862216, u64=139833552118088}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31557] epoll_pwait(18,  <unfinished ...>
[pid 31556] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] write(2, "29", 2 <unfinished ...>
29[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31554] <... write resumed>)        = 2
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] write(2, "\n", 1 <unfinished ...>

[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31554] <... write resumed>)        = 1
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31547] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31547] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31547] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31547] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31547] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31547] <... epoll_ctl resumed>)    = 0
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31547] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31551] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31551] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31547] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31551] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31547] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31547] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31547] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31547] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31547] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31547] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31547] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31542] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31542] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31547] <... epoll_ctl resumed>)    = 0
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862312, u64=139833552118184}} <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31549] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31548] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862344, u64=139833552118216}} <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31549] <... epoll_ctl resumed>)    = 0
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862312, u64=139833552118184}}], 1, -1, NULL, 128) = 1
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862344, u64=139833552118216}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31549] epoll_pwait(18,  <unfinished ...>
[pid 31548] <... epoll_ctl resumed>)    = 0
[pid 31547] epoll_pwait(18,  <unfinished ...>
[pid 31542] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31548] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31553] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31553] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31554] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31554] <... epoll_ctl resumed>)    = 0
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31554] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862152, u64=139833552118024}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862152, u64=139833552118024}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31553] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31550] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31555] epoll_pwait(18,  <unfinished ...>
[pid 31550] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862184, u64=139833552118056}} <unfinished ...>
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862184, u64=139833552118056}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31550] epoll_pwait(18,  <unfinished ...>
[pid 31558] <... epoll_ctl resumed>)    = 0
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31552] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=2301862248, u64=139833552118120}} <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=2301862248, u64=139833552118120}}], 1, -1, NULL, 128) = 1
[pid 31552] <... epoll_ctl resumed>)    = 0
[pid 31558] epoll_pwait(18,  <unfinished ...>
[pid 31552] futex(0x2671d8, FUTEX_WAKE, 1) = 1
[pid 31543] <... futex resumed>)        = 0
[pid 31552] write(19, "\1\1\1\1\1\1\1\1", 8 <unfinished ...>
[pid 31543] exit(0 <unfinished ...>
[pid 31558] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31552] <... write resumed>)        = 8
[pid 31558] exit(2519552 <unfinished ...>
[pid 31555] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31554] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31553] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31550] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31552] epoll_pwait(18,  <unfinished ...>
[pid 31548] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31543] <... exit resumed>)         = ?
[pid 31542] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31558] <... exit resumed>)         = ?
[pid 31557] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31556] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31555] exit(2519552 <unfinished ...>
[pid 31554] exit(2519552 <unfinished ...>
[pid 31553] exit(2519552 <unfinished ...>
[pid 31552] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31550] exit(2519552 <unfinished ...>
[pid 31549] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31548] exit(2519552 <unfinished ...>
[pid 31547] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31542] munmap(0x7f2d88337000, 16785408 <unfinished ...>
[pid 31546] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31545] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31544] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31543] +++ exited with 0 +++
[pid 31542] <... munmap resumed>)       = 0
[pid 31558] +++ exited with 0 +++
[pid 31557] exit(2519552 <unfinished ...>
[pid 31556] exit(2519552 <unfinished ...>
[pid 31555] <... exit resumed>)         = ?
[pid 31554] <... exit resumed>)         = ?
[pid 31553] <... exit resumed>)         = ?
[pid 31552] exit(2519552 <unfinished ...>
[pid 31551] <... epoll_pwait resumed>[{EPOLLIN, {u32=2519648, u64=2519648}}], 1, -1, NULL, 128) = 1
[pid 31550] <... exit resumed>)         = ?
[pid 31549] exit(2519552 <unfinished ...>
[pid 31547] exit(2519552 <unfinished ...>
[pid 31546] exit(2519552 <unfinished ...>
[pid 31544] exit(2519552 <unfinished ...>
[pid 31542] futex(0x7f2d88336000, FUTEX_WAIT, 31544, NULL <unfinished ...>
[pid 31557] <... exit resumed>)         = ?
[pid 31556] <... exit resumed>)         = ?
[pid 31555] +++ exited with 0 +++
[pid 31554] +++ exited with 0 +++
[pid 31553] +++ exited with 0 +++
[pid 31552] <... exit resumed>)         = ?
[pid 31550] +++ exited with 0 +++
[pid 31549] <... exit resumed>)         = ?
[pid 31548] <... exit resumed>)         = ?
[pid 31547] <... exit resumed>)         = ?
[pid 31546] <... exit resumed>)         = ?
[pid 31545] exit(2519552 <unfinished ...>
[pid 31544] <... exit resumed>)         = ?
[pid 31557] +++ exited with 0 +++
[pid 31556] +++ exited with 0 +++
[pid 31552] +++ exited with 0 +++
[pid 31551] exit(2519552 <unfinished ...>
[pid 31549] +++ exited with 0 +++
[pid 31542] <... futex resumed>)        = 0
[pid 31547] +++ exited with 0 +++
[pid 31546] +++ exited with 0 +++
[pid 31544] +++ exited with 0 +++
[pid 31542] munmap(0x7f2d87335000, 16785408 <unfinished ...>
[pid 31545] <... exit resumed>)         = ?
[pid 31548] +++ exited with 0 +++
[pid 31542] <... munmap resumed>)       = 0
[pid 31545] +++ exited with 0 +++
[pid 31542] munmap(0x7f2d86333000, 16785408 <unfinished ...>
[pid 31551] <... exit resumed>)         = ?
[pid 31542] <... munmap resumed>)       = 0
[pid 31542] munmap(0x7f2d85331000, 16785408 <unfinished ...>
[pid 31551] +++ exited with 0 +++
<... munmap resumed>)                   = 0
munmap(0x7f2d8432f000, 16785408)        = 0
munmap(0x7f2d8332d000, 16785408)        = 0
munmap(0x7f2d8232b000, 16785408)        = 0
munmap(0x7f2d81329000, 16785408)        = 0
munmap(0x7f2d80327000, 16785408)        = 0
munmap(0x7f2d7f325000, 16785408)        = 0
munmap(0x7f2d7e323000, 16785408)        = 0
munmap(0x7f2d7d321000, 16785408)        = 0
munmap(0x7f2d7c31f000, 16785408)        = 0
munmap(0x7f2d7b31d000, 16785408)        = 0
munmap(0x7f2d7a31b000, 16785408)        = 0
munmap(0x7f2d79319000, 16785408)        = 0
close(19)                               = 0
close(14)                               = 0
close(12)                               = 0
close(11)                               = 0
close(17)                               = 0
close(16)                               = 0
close(13)                               = 0
close(15)                               = 0
close(10)                               = 0
close(9)                                = 0
close(8)                                = 0
close(7)                                = 0
close(6)                                = 0
close(5)                                = 0
close(4)                                = 0
close(3)                                = 0
close(18)                               = 0
munmap(0x7f2d8933a000, 480)             = 0
munmap(0x7f2d89339000, 120)             = 0
exit_group(0)                           = ?
+++ exited with 0 +++
</pre>
</details>

In the Go strace, the `sigaction` stuff appears to all be setup. It creates
only 1 thread, which appears to hand off work, if any, without interacting
with the kernel. The only curious part is the `select` calls with no file
descriptors, which seem to be used as sleep():

```
[pid 23800] select(0, NULL, NULL, NULL, {tv_sec=0, tv_usec=20} <unfinished ...>
```

In the Zig strace, we have a lot of epoll noise as 16 worker threads each do
a tiny amount of work before telling the kernel to dispatch jobs to workers.
This leads to a lot of contention on a synchronization mutex in the
event loop implementation, as we'll see in the next section.

## Performance

To measure performance, I increased the main iteration count to a larger
number and piped stdout to a file, measuring total application runtime.

Note that we still use
[ReleaseSafe](https://ziglang.org/documentation/master/#ReleaseSafe)
rather than
[ReleaseFast](https://ziglang.org/documentation/master/#ReleaseFast)
for the Zig build, for a good faith comparison.

```diff
--- a/sieve.go
+++ b/sieve.go
@@ -26,7 +26,7 @@ func Filter(in <-chan int, out chan<- int, prime int) {
 func main() {
        ch := make(chan int) // Create a new channel.
        go Generate(ch)      // Launch Generate goroutine.
-       for i := 0; i < 10; i++ {
+       for i := 0; i < 10000; i++ {
                prime := <-ch
                fmt.Println(prime)
                ch1 := make(chan int)
```

```diff
--- a/sieve.zig
+++ b/sieve.zig
@@ -45,13 +45,20 @@ pub fn main() anyerror!void {
     // In this case we let it run forever, not bothering to `await`.
     _ = async generate(ch);
 
+    const stdout_file = try std.io.getStdOut();
+    const stdout_unbuffered = &stdout_file.outStream().stream;
+    var buffered_stream = std.io.BufferedOutStream(std.fs.File.WriteError).init(stdout_unbuffered);
+    const stdout = &buffered_stream.stream;
+
     var i: usize = 0;
-    while (i < 10) : (i += 1) {
+    while (i < 10000) : (i += 1) {
         const prime = ch.get();
-        std.debug.warn("{}\n", prime);
+        try stdout.print("{}\n", prime);
         const ch1 = try allocator.create(Channel(u32));
         ch1.init([0]u32{});
         (try allocator.create(@Frame(filter))).* = async filter(ch, ch1, prime);
         ch = ch1;
     }
+
+    try buffered_stream.flush();
 }
```

 * sieve.go - 0.06 seconds
 * sieve.zig - 2.80 seconds

Stark difference! Zig's standard library event loop implementation definitely
needs work.

Using perf, I was able to find a clue:

```
  41.57%  [kernel]          [k] native_queued_spin_lock_slowpath
  10.19%  sieve-zig         [.] std.atomic.stack.Stack(std.event.loop.EventFd).pop
   7.44%  [kernel]          [k] try_to_wake_up
   3.70%  sieve-zig         [.] std.mutex.Mutex.acquire
```

Most of the time is spent on resource contention in the event loop. This is a
nice clue on how to improve it.

## Idiomatic Zig Implementation

With full awareness that the Go code is provided to demonstrate channels and
goroutines, I still think it is worth pointing out what a more idiomatic
solution would be to a problem like this, which is a CPU bound operation with
no concurrent I/O.

And that solution is to not use any concurrency. In this problem, each step
inherently depends on the previous step, so concurrency only introduces
overhead.

sieve2.zig demonstrates this. Compared to the directly-ported sieve.zig:

 * Binary Size: 698 KB (half as large)
 * Compilation speed: 0.5 sec (0.3 sec faster)
 * Performance: 0 seconds (would need to increase the output len significantly
   to see any time).
 * Strace

```
execve("./sieve2", ["./sieve2"], 0x7fff76bd84d0 /* 62 vars */) = 0
rt_sigaction(SIGSEGV, {sa_handler=0x20e2c0, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART|SA_RESETHAND|SA_SIGINFO, sa_restorer=0x202380}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
write(1, "2\n3\n5\n7\n11\n13\n17\n19\n23\n29\n31\n37\n"..., 4096) = 4096
write(1, "1\n6673\n6679\n6689\n6691\n6701\n6703\n"..., 707) = 707
exit(0)                                 = ?
+++ exited with 0 +++
```

The fact that this idiomatic implementation that does not use any concurrency
is faster and simpler than both the original Go and Zig versions, I think means
that this is not a great "real world" example to of Go's concurrency. It's
good for teaching how Go works, but this is not how one would write real code.

In this repository, I'm on the hunt for more real world examples to compare.
