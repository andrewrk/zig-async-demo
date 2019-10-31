# Sieve of Eratosthenes

 * sieve.go - from https://golang.org/doc/play/sieve.go
 * sieve.zig - direct port to zig. 

Note: this would not be the recommended way to implement a
concurrent prime sieve in Zig; this implementation is intended
to serve as a direct port of the reference Go code.

In this README I have experimented with the x86_64-linux-gnu target.
This laptop has a Intel(R) Core(TM) i9-9980HK CPU @ 2.40GHz.

# Versions

 * go version go1.4-bootstrap-20161024 linux/amd64
 * zig 0.5.0+d3d3e4e3

# Output

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

# Binary Size

Go does not have a configurable build mode, so, which Zig build mode should
we choose that is closest to Go's? This would be
[ReleaseSafe](https://ziglang.org/documentation/master/#ReleaseSafe).

```
go build sieve.go
zig build-exe sieve.zig --release-safe
```

 * sieve (Go) - 1.9 MiB
 * sieve (Zig) - 976 KiB

# Compilation Speed

In this case it makes more sense to measure Zig's debug build mode:

```
zig build-exe sieve.zig
```

 * sieve.go - 0.12 seconds
 * sieve.zig - 0.80 seconds

Go is certainly going to win on this comparison until Zig has a
non-LLVM backend. Here's a timing report from Zig with diagnostics
enabled. You can see most of the time is spent waiting for LLVM:

```
                Name       Start         End    Duration     Percent
          Initialize      0.0000      0.0005      0.0005      0.0004
   Semantic Analysis      0.0005      0.3201      0.3196      0.2587
     Code Generation      0.3201      0.4026      0.0826      0.0668
    LLVM Emit Output      0.4026      1.2049      0.8022      0.6493
  Build Dependencies      1.2049      1.2053      0.0004      0.0004
           LLVM Link      1.2053      1.2355      0.0302      0.0244
               Total      0.0000      1.2355      1.2355      1.0000
```

# strace

<details>
<summary>Go strace</summary>
<br>
<pre>
execve("./sieve-go", ["./sieve-go"], 0x7ffcef70f258 /* 62 vars */) = 0
arch_prctl(ARCH_SET_FS, 0x556cf0)       = 0
sched_getaffinity(0, 128, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]) = 48
mmap(0xc000000000, 65536, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xc000000000
munmap(0xc000000000, 65536)             = 0
mmap(NULL, 262144, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f184a405000
mmap(0xc208000000, 1048576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xc208000000
mmap(0xc207ff0000, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xc207ff0000
mmap(0xc000000000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xc000000000
mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f184a3f5000
mmap(NULL, 1439992, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f184a295000
sigaltstack({ss_sp=0xc208002000, ss_flags=0, ss_size=32768}, NULL) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
rt_sigaction(SIGHUP, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGHUP, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGINT, NULL, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGINT, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGQUIT, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGILL, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGTRAP, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGABRT, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGBUS, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGFPE, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGUSR1, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGSEGV, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGUSR2, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGPIPE, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGALRM, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGTERM, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGSTKFLT, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGCHLD, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGURG, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGXCPU, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGXFSZ, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGVTALRM, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGPROF, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGWINCH, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGIO, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGPWR, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGSYS, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_2, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_3, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_4, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_5, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_6, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_7, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_8, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_9, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_10, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_11, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_12, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_13, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_14, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_15, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_16, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_17, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_18, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_19, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_20, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_21, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_22, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_23, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_24, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_25, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_26, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_27, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_28, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_29, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_30, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_31, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigaction(SIGRT_32, {sa_handler=0x437320, sa_mask=~[], sa_flags=SA_RESTORER|SA_ONSTACK|SA_RESTART|SA_SIGINFO, sa_restorer=0x437390}, NULL, 8) = 0
rt_sigprocmask(SIG_SETMASK, ~[], [], 8) = 0
clone(child_stack=0xc208030000, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD) = 23800
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
strace: Process 23800 attached
[pid 23800] gettid()                    = 23800
[pid 23800] arch_prctl(ARCH_SET_FS, 0xc208020058) = 0
[pid 23800] sigaltstack({ss_sp=0xc208022000, ss_flags=0, ss_size=32768}, NULL) = 0
[pid 23800] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 23800] select(0, NULL, NULL, NULL, {tv_sec=0, tv_usec=20} <unfinished ...>
[pid 23799] write(1, "2\n", 22
)          = 2
[pid 23799] write(1, "3\n", 23
)          = 2
[pid 23799] write(1, "5\n", 25
)          = 2
[pid 23799] write(1, "7\n", 2 <unfinished ...>
7
[pid 23800] <... select resumed>)       = 0 (Timeout)
[pid 23799] <... write resumed>)        = 2
[pid 23800] select(0, NULL, NULL, NULL, {tv_sec=0, tv_usec=20} <unfinished ...>
[pid 23799] write(1, "11\n", 311
)         = 3
[pid 23800] <... select resumed>)       = 0 (Timeout)
[pid 23799] write(1, "13\n", 3 <unfinished ...>
13
[pid 23800] select(0, NULL, NULL, NULL, {tv_sec=0, tv_usec=20} <unfinished ...>
[pid 23799] <... write resumed>)        = 3
[pid 23799] write(1, "17\n", 317
)         = 3
[pid 23799] write(1, "19\n", 319
)         = 3
[pid 23799] write(1, "23\n", 323
)         = 3
[pid 23800] <... select resumed>)       = 0 (Timeout)
[pid 23800] select(0, NULL, NULL, NULL, {tv_sec=0, tv_usec=20} <unfinished ...>
[pid 23799] write(1, "29\n", 329
)         = 3
[pid 23799] exit_group(0)               = ?
[pid 23800] <... select resumed> <unfinished ...>) = ?
[pid 23800] +++ exited with 0 +++
+++ exited with 0 +++
</pre>
</details>


<details>
<summary>Go strace</summary>
<br>
<pre>
execve("./sieve-zig", ["./sieve-zig"], 0x7fffaedd9578 /* 62 vars */) = 0
rt_sigaction(SIGSEGV, {sa_handler=0x25af80, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART|SA_RESETHAND|SA_SIGINFO, sa_restorer=0x2065b0}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
sched_getaffinity(0, 128, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]) = 48
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94e1749000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94e1748000
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
epoll_ctl(18, EPOLL_CTL_ADD, 19, {EPOLLIN, {u32=2515552, u64=2515552}}) = 0
mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94e0746000
mprotect(0x7f94e0746000, 16785408, PROT_READ|PROT_WRITE) = 0
clone(child_stack=0x7f94e1746ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[23828], child_tidptr=0x7f94e1747000) = 23828
strace: Process 23828 attached
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94df744000
[pid 23828] futex(0x2661d8, FUTEX_WAIT, 0, NULL <unfinished ...>
[pid 23827] mprotect(0x7f94df744000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94e0744ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 23829 attached
, parent_tid=[23829], child_tidptr=0x7f94e0745000) = 23829
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 23829] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... mmap resumed>)         = 0x7f94de742000
[pid 23827] mprotect(0x7f94de742000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94df742ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 23830 attached
, parent_tid=[23830], child_tidptr=0x7f94df743000) = 23830
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94dd740000
[pid 23830] epoll_pwait(18,  <unfinished ...>
[pid 23827] mprotect(0x7f94dd740000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94de740ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[23831], child_tidptr=0x7f94de741000) = 23831
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94dc73e000
[pid 23827] mprotect(0x7f94dc73e000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94dd73eff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[23832], child_tidptr=0x7f94dd73f000) = 23832
strace: Process 23832 attached
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 23832] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... mmap resumed>)         = 0x7f94db73c000
[pid 23827] mprotect(0x7f94db73c000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94dc73cff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 23833 attached
, parent_tid=[23833], child_tidptr=0x7f94dc73d000) = 23833
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94da73a000
[pid 23827] mprotect(0x7f94da73a000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94db73aff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 23834 attached
, parent_tid=[23834], child_tidptr=0x7f94db73b000) = 23834
[pid 23834] epoll_pwait(18,  <unfinished ...>
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94d9738000
[pid 23827] mprotect(0x7f94d9738000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94da738ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[23835], child_tidptr=0x7f94da739000) = 23835
strace: Process 23835 attached
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94d8736000
[pid 23835] epoll_pwait(18,  <unfinished ...>
[pid 23827] mprotect(0x7f94d8736000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94d9736ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 23836 attached
, parent_tid=[23836], child_tidptr=0x7f94d9737000) = 23836
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94d7734000
[pid 23827] mprotect(0x7f94d7734000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94d8734ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 23831 attached
, parent_tid=[23837], child_tidptr=0x7f94d8735000) = 23837
strace: Process 23837 attached
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94d6732000
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23827] mprotect(0x7f94d6732000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94d7732ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 23841 attached
, parent_tid=[23841], child_tidptr=0x7f94d7733000) = 23841
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0 <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... mmap resumed>)         = 0x7f94d5730000
[pid 23827] mprotect(0x7f94d5730000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94d6730ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[23842], child_tidptr=0x7f94d6731000) = 23842
strace: Process 23842 attached
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94d472e000
[pid 23827] mprotect(0x7f94d472e000, 16785408, PROT_READ|PROT_WRITE <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... mprotect resumed>)     = 0
[pid 23827] clone(child_stack=0x7f94d572eff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[23843], child_tidptr=0x7f94d572f000) = 23843
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94d372c000
[pid 23827] mprotect(0x7f94d372c000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94d472cff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 23844 attached
, parent_tid=[23844], child_tidptr=0x7f94d472d000) = 23844
strace: Process 23843 attached
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94d272a000
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23827] mprotect(0x7f94d272a000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94d372aff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000, parent_tid=[23845], child_tidptr=0x7f94d372b000) = 23845
[pid 23827] mmap(NULL, 16785408, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94d1728000
[pid 23827] mprotect(0x7f94d1728000, 16785408, PROT_READ|PROT_WRITE) = 0
[pid 23827] clone(child_stack=0x7f94d2728ff8, flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID|0x400000strace: Process 23846 attached
, parent_tid=[23846], child_tidptr=0x7f94d2729000) = 23846
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23827] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f94d1727000
[pid 23827] epoll_ctl(18, EPOLL_CTL_ADD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}}) = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_ADD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] write(2, "2", 1 <unfinished ...>
2[pid 23827] <... epoll_ctl resumed>)    = 0
strace: Process 23845 attached
[pid 23846] <... write resumed>)        = 1
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] write(2, "\n", 1 <unfinished ...>

[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... write resumed>)        = 1
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}}) = 0
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}}) = 0
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23827] write(2, "3", 1 <unfinished ...>
3[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23827] <... write resumed>)        = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23827] write(2, "\n", 1 <unfinished ...>

[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... write resumed>)        = 1
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_ctl(18, EPOLL_CTL_ADD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_ADD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] write(2, "5", 1 <unfinished ...>
5[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... write resumed>)        = 1
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23844] write(2, "\n", 1 <unfinished ...>

[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] <... write resumed>)        = 1
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23844] write(2, "7", 1 <unfinished ...>
7[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... write resumed>)        = 1
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] write(2, "\n", 1 <unfinished ...>

[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] <... write resumed>)        = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23843] epoll_pwait(18, [{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_ADD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23837] write(2, "11", 211 <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23837] <... write resumed>)        = 2
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23837] write(2, "\n", 1 <unfinished ...>

[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23837] <... write resumed>)        = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] write(2, "13", 2 <unfinished ...>
13[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23842] <... write resumed>)        = 2
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] write(2, "\n", 1 <unfinished ...>

[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23842] <... write resumed>)        = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23836] write(2, "17", 2 <unfinished ...>
17[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... write resumed>)        = 2
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23836] write(2, "\n", 1 <unfinished ...>

[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23836] <... write resumed>)        = 1
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23845] futex(0x2661b0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 23844] futex(0x2661b0, FUTEX_WAIT_PRIVATE, 2, NULL <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23845] <... futex resumed>)        = 0
[pid 23844] <... futex resumed>)        = -1 EAGAIN (Resource temporarily unavailable)
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] futex(0x2661b0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23844] <... futex resumed>)        = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23841] write(2, "19", 219 <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23841] <... write resumed>)        = 2
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23841] write(2, "\n", 1
 <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23841] <... write resumed>)        = 1
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] write(2, "23", 223 <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... write resumed>)        = 2
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] write(2, "\n", 1
 <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... write resumed>)        = 1
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_ADD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23837] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23835] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23837] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23841] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23837] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 14, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513000, u64=140277414400360}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23841] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513000, u64=140277414400360}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23841] epoll_pwait(18,  <unfinished ...>
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_ADD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 17, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513096, u64=140277414400456}} <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23835] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23835] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513096, u64=140277414400456}}], 1, -1, NULL, 128) = 1
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23835] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23846] futex(0x2661b0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 23843] futex(0x2661b0, FUTEX_WAIT_PRIVATE, 2, NULL <unfinished ...>
[pid 23842] write(2, "29", 2 <unfinished ...>
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
29[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23846] <... futex resumed>)        = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23843] <... futex resumed>)        = -1 EAGAIN (Resource temporarily unavailable)
[pid 23842] <... write resumed>)        = 2
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] write(2, "\n", 1
 <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] futex(0x2661b0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
[pid 23842] <... write resumed>)        = 1
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23843] <... futex resumed>)        = 0
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23835] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23835] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23835] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23835] epoll_pwait(18,  <unfinished ...>
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23835] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23835] epoll_pwait(18,  <unfinished ...>
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23835] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23833] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23833] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 12, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512936, u64=140277414400296}} <unfinished ...>
[pid 23835] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512936, u64=140277414400296}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23835] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23835] epoll_pwait(18,  <unfinished ...>
[pid 23833] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23843] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23843] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23843] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23831] epoll_ctl(18, EPOLL_CTL_MOD, 13, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512968, u64=140277414400328}} <unfinished ...>
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23831] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23831] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512968, u64=140277414400328}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}}) = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23842] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23844] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23842] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23844] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23844] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 15, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513032, u64=140277414400392}} <unfinished ...>
[pid 23836] epoll_ctl(18, EPOLL_CTL_MOD, 11, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782512904, u64=140277414400264}} <unfinished ...>
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513032, u64=140277414400392}}], 1, -1, NULL, 128) = 1
[pid 23827] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782512904, u64=140277414400264}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_ctl resumed>)    = 0
[pid 23827] <... epoll_ctl resumed>)    = 0
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23845] epoll_pwait(18,  <unfinished ...>
[pid 23842] epoll_pwait(18,  <unfinished ...>
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23836] epoll_pwait(18,  <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] epoll_ctl(18, EPOLL_CTL_MOD, 16, {EPOLLIN|EPOLLOUT|EPOLLONESHOT|EPOLLET, {u32=3782513064, u64=140277414400424}} <unfinished ...>
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN|EPOLLOUT, {u32=3782513064, u64=140277414400424}}], 1, -1, NULL, 128) = 1
[pid 23846] <... epoll_ctl resumed>)    = 0
[pid 23827] epoll_pwait(18,  <unfinished ...>
[pid 23846] futex(0x2661d8, FUTEX_WAKE, 1) = 1
[pid 23846] write(19, "\1\1\1\1\1\1\1\1", 8 <unfinished ...>
[pid 23828] <... futex resumed>)        = 0
[pid 23846] <... write resumed>)        = 8
[pid 23827] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23846] epoll_pwait(18,  <unfinished ...>
[pid 23845] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23844] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23842] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23836] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23827] futex(0x7f94e1747000, FUTEX_WAIT, 23828, NULL <unfinished ...>
[pid 23846] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23845] exit(2515456 <unfinished ...>
[pid 23844] exit(2515456 <unfinished ...>
[pid 23843] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23842] exit(2515456 <unfinished ...>
[pid 23841] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23837] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23836] exit(2515456 <unfinished ...>
[pid 23835] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23834] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23833] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23832] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23831] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23830] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23829] <... epoll_pwait resumed>[{EPOLLIN, {u32=2515552, u64=2515552}}], 1, -1, NULL, 128) = 1
[pid 23828] exit(0 <unfinished ...>
[pid 23846] exit(2515456 <unfinished ...>
[pid 23845] <... exit resumed>)         = ?
[pid 23844] <... exit resumed>)         = ?
[pid 23843] exit(2515456 <unfinished ...>
[pid 23842] <... exit resumed>)         = ?
[pid 23841] exit(2515456 <unfinished ...>
[pid 23837] exit(2515456 <unfinished ...>
[pid 23836] <... exit resumed>)         = ?
[pid 23835] exit(2515456 <unfinished ...>
[pid 23834] exit(2515456 <unfinished ...>
[pid 23833] exit(2515456 <unfinished ...>
[pid 23832] exit(2515456 <unfinished ...>
[pid 23831] exit(2515456 <unfinished ...>
[pid 23830] exit(2515456 <unfinished ...>
[pid 23829] exit(2515456 <unfinished ...>
[pid 23846] <... exit resumed>)         = ?
[pid 23845] +++ exited with 0 +++
[pid 23844] +++ exited with 0 +++
[pid 23842] +++ exited with 0 +++
[pid 23841] <... exit resumed>)         = ?
[pid 23837] <... exit resumed>)         = ?
[pid 23836] +++ exited with 0 +++
[pid 23835] <... exit resumed>)         = ?
[pid 23843] <... exit resumed>)         = ?
[pid 23834] <... exit resumed>)         = ?
[pid 23832] <... exit resumed>)         = ?
[pid 23831] <... exit resumed>)         = ?
[pid 23830] <... exit resumed>)         = ?
[pid 23829] <... exit resumed>)         = ?
[pid 23828] <... exit resumed>)         = ?
[pid 23846] +++ exited with 0 +++
[pid 23843] +++ exited with 0 +++
[pid 23841] +++ exited with 0 +++
[pid 23837] +++ exited with 0 +++
[pid 23835] +++ exited with 0 +++
[pid 23834] +++ exited with 0 +++
[pid 23833] <... exit resumed>)         = ?
[pid 23832] +++ exited with 0 +++
[pid 23831] +++ exited with 0 +++
[pid 23830] +++ exited with 0 +++
[pid 23829] +++ exited with 0 +++
[pid 23828] +++ exited with 0 +++
[pid 23827] <... futex resumed>)        = 0
[pid 23833] +++ exited with 0 +++
munmap(0x7f94e0746000, 16785408)        = 0
munmap(0x7f94df744000, 16785408)        = 0
munmap(0x7f94de742000, 16785408)        = 0
munmap(0x7f94dd740000, 16785408)        = 0
munmap(0x7f94dc73e000, 16785408)        = 0
munmap(0x7f94db73c000, 16785408)        = 0
munmap(0x7f94da73a000, 16785408)        = 0
munmap(0x7f94d9738000, 16785408)        = 0
munmap(0x7f94d8736000, 16785408)        = 0
munmap(0x7f94d7734000, 16785408)        = 0
munmap(0x7f94d6732000, 16785408)        = 0
munmap(0x7f94d5730000, 16785408)        = 0
munmap(0x7f94d472e000, 16785408)        = 0
munmap(0x7f94d372c000, 16785408)        = 0
munmap(0x7f94d272a000, 16785408)        = 0
munmap(0x7f94d1728000, 16785408)        = 0
close(19)                               = 0
close(16)                               = 0
close(11)                               = 0
close(15)                               = 0
close(13)                               = 0
close(12)                               = 0
close(17)                               = 0
close(14)                               = 0
close(10)                               = 0
close(9)                                = 0
close(8)                                = 0
close(7)                                = 0
close(6)                                = 0
close(5)                                = 0
close(4)                                = 0
close(3)                                = 0
close(18)                               = 0
munmap(0x7f94e1749000, 480)             = 0
munmap(0x7f94e1748000, 120)             = 0
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

# Performance

To measure performance, I increased the main iteration count to a larger
number and piped stdout to a file, measuring total application runtime.

Note that we still use
[ReleaseSafe](https://ziglang.org/documentation/master/#ReleaseSafe).
rather than
[ReleaseFast](https://ziglang.org/documentation/master/#ReleaseFast).
for the Zig build, for a good faith comparison.

```diff
--- a/sieve.go
+++ b/sieve.go
@@ -26,7 +26,7 @@ func Filter(in <-chan int, out chan<- int, prime int) {
 func main() {
        ch := make(chan int) // Create a new channel.
        go Generate(ch)      // Launch Generate goroutine.
-       for i := 0; i < 10; i++ {
+       for i := 0; i < 1000; i++ {
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
+    while (i < 1000) : (i += 1) {
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

 * sieve.go - 0.12 seconds
 * sieve.zig - 2.53 seconds

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

# Idiomatic Zig Implementation

With full awareness that the Go code is provided to demonstrate channels and
goroutines, I still think it is worth pointing out what a more idiomatic
solution would be to a problem like this, which is a CPU bound operation with
no concurrent I/O.

And that solution is to not use any concurrency. In this problem, each step
inherently depends on the previous step, so concurrency only introduces
overhead.

sieve2.zig demonstrates this. Compared to the directly-ported sieve.zig:

 * Binary Size: 540 KB (half as large)
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
