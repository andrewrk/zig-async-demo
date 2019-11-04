const std = @import("std");
const Allocator = std.mem.Allocator;
const BigInt = std.math.big.Int;
const Channel = std.event.Channel;

pub const io_mode = .evented;

pub fn main() !void {
    try fact(3000000);
}

fn fact(n: u64) !void {
    const allocator = std.heap.c_allocator;

    var arena = std.heap.ArenaAllocator.init(allocator);
    const arenaAllocator = &arena.allocator;

    const cores = previousPowerOfTwo(try std.Thread.cpuCount());

    if (n < cores) {
        var x = try BigInt.init(allocator);
        defer x.deinit();
        try bigIntMultRange(allocator, &x, 1, n);
        return;
    }

    var buffer = try arenaAllocator.alloc(*BigInt, cores);
    var out = try arenaAllocator.create(Channel(*BigInt));
    out.init(buffer);

    var i: usize = 0;
    while (i < cores) : (i += 1) {
        const start = @divFloor(i * n, cores) + 1;
        const stop = @divFloor((i + 1) * n, cores);
        const buf = try arenaAllocator.alloc(u64, 2);
        const in = try arenaAllocator.create(Channel(u64));
        in.init(buf);
        (try arenaAllocator.create(@Frame(parallelMulRange))).* = async parallelMulRange(allocator, in, out);
        in.put(start);
        in.put(stop);
    }

    var in = out;
    var procs = cores;
    while (procs > 1) {
        buffer = try arenaAllocator.alloc(*BigInt, procs);
        out = try arenaAllocator.create(Channel(*BigInt));
        out.init(buffer);
        var odd = procs % 2 == 1;
        procs = @divFloor(procs, 2);
        i = 0;
        while (i < procs) : (i += 1) {
            (try arenaAllocator.create(@Frame(reduceMul))).* = async reduceMul(in, out);
        }
        if (odd) {
            out.put(in.get());
            procs += 1;
        }
        in = out;
    }
    var x = in.get();
}

fn previousPowerOfTwo(x: usize) usize {
    comptime var bits = usize.bit_count;
    comptime var i = 1;
    var y = x;
    inline while (i < bits) : (i *= 2) {
        y = y | (y >> i);
    }
    return y - (y >> 1);
}

fn reduceMul(in: *Channel(*BigInt), out: *Channel(*BigInt)) !void {
    const a = in.get();
    const b = in.get();
    defer b.deinit();

    try BigInt.mul(a, a.*, b.*);
    out.put(a);
}

fn parallelMulRange(allocator: *Allocator, in: *Channel(u64), out: *Channel(*BigInt)) !void {
    var start = in.get();
    var stop = in.get();
    var x = try BigInt.init(allocator);
    try bigIntMultRange(allocator, &x, start, stop);
    out.put(&x);
}

fn bigIntMultRange(allocator: *Allocator, out: *BigInt, a: u64, b: u64) anyerror!void {
    if (a == b) {
        try out.set(a);
        return;
    }

    var l = try BigInt.init(allocator);
    var r = try BigInt.init(allocator);
    defer l.deinit();
    defer r.deinit();

    const m = @divFloor((a + b), 2);
    try bigIntMultRange(allocator, &l, a, m);
    try bigIntMultRange(allocator, &r, m + 1, b);

    try BigInt.mul(out, l, r);
}
