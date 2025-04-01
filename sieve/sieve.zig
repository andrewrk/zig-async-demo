// A concurrent prime sieve
// Note: this would not be the recommended way to implement a
// concurrent prime sieve in Zig; this implementation is intended
// to serve as a direct port of the reference Go code.

const std = @import("std");
const Io = std.Io;
const Queue = std.Io.Queue;

// Send the sequence 2, 3, 4, ... to channel 'ch'.
fn generate(io: Io, ch: *Queue(u32)) void {
    var i: u32 = 2;
    while (true) : (i += 1) {
        ch.putOne(io, i) catch break;
    }
}

// Copy the values from channel 'in' to channel 'out',
// removing those divisible by 'prime'.
fn filter(io: Io, in: *Queue(u32), out: *Queue(u32), prime: u32) void {
    while (true) {
        const i = in.getOne(io) catch break;
        if (i % prime != 0) {
            out.putOne(io, i) catch break;
        }
    }
}

// The prime sieve: Daisy-chain Filter processes.
pub fn main() anyerror!void {
    var debug_allocator: std.heap.DebugAllocator(.{}) = .init;
    const gpa = debug_allocator.allocator();
    //const gpa = std.heap.smp_allocator;

    var arena_instance = std.heap.ArenaAllocator.init(gpa);
    const arena = arena_instance.allocator();

    var event_loop: Io.EventLoop = undefined;
    try event_loop.init(arena);
    defer event_loop.deinit();
    const io = event_loop.io();

    //var thread_pool: std.Thread.Pool = undefined;
    //try thread_pool.init(.{ .allocator = gpa });
    //defer thread_pool.deinit();
    //const io = thread_pool.io();

    var ch = try arena.create(Queue(u32));
    ch.* = .init(&.{}); // Unbuffered channel.

    io.go(generate, .{ io, ch });

    var bw = std.io.bufferedWriter(std.io.getStdOut().writer());
    const stdout = bw.writer();

    for (0..10) |_| {
        const prime = ch.getOne(io) catch break;
        try stdout.print("{d}\n", .{prime});
        const ch1 = try arena.create(Queue(u32));
        ch1.* = .init(&.{});
        io.go(filter, .{ io, ch, ch1, prime });
        ch = ch1;
    }
    try bw.flush();
    std.process.exit(0);
}
