const c = @cImport({
    @cInclude("gmp.h");
});
const std = @import("std");
const Channel = std.event.Channel;

pub const io_mode = .evented;

pub fn main() !void {
    try fact(3000000);
}

fn fact(n: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    const allocator = &arena.allocator;

    const cores = previousPowerOfTwo(try std.Thread.cpuCount());

    if (n < cores) {
        var x: c.mpz_t = undefined;
        c.mpz_init(&x);
        bigIntMulRange(&x, 1, n);
        c.mpz_clear(&x);
        return;
    }

    var buffer = try allocator.alloc(*c.mpz_t, cores);
    var out = try allocator.create(Channel(*c.mpz_t));
    out.init(buffer);

    var i: usize = 0;
    while (i < cores) : (i += 1) {
        const start = @divFloor(i * n, cores) + 1;
        const stop = @divFloor((i + 1) * n, cores);
        const buf = try allocator.alloc(u64, 2);
        const in = try allocator.create(Channel(u64));
        in.init(buf);
        (try allocator.create(@Frame(parallelMulRange))).* = async parallelMulRange(in, out);
        in.put(start);
        in.put(stop);
    }

    var in = out;
    var procs = cores;

    while (procs > 1) {
        buffer = try allocator.alloc(*c.mpz_t, procs);
        out = try allocator.create(Channel(*c.mpz_t));
        out.init(buffer);
        var odd = procs % 2 == 1;
        procs = @divFloor(procs, 2);
        i = 0;
        while (i < procs) : (i += 1) {
            (try allocator.create(@Frame(reduceMul))).* = async reduceMul(in, out);
        }
        if (odd) {
            out.put(in.get());
            procs += 1;
        }
        in = out;
    }
    c.mpz_clear(in.get());
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

fn reduceMul(in: *Channel(*c.mpz_t), out: *Channel(*c.mpz_t)) void {
    const a = in.get();
    const b = in.get();

    c.mpz_mul(a, a, b);
    out.put(a);
    c.mpz_clear(b);
}

fn parallelMulRange(in: *Channel(u64), out: *Channel(*c.mpz_t)) void {
    var start = in.get();
    var stop = in.get();
    var x: c.mpz_t = undefined;
    c.mpz_init(&x);
    bigIntMulRange(&x, start, stop);
    out.put(&x);
}

fn bigIntMulRange(out: *c.mpz_t, a: u64, b: u64) void {
    if (a == b) {
        c.mpz_init_set_ui(out, a);
        return;
    }

    var l: c.mpz_t = undefined;
    c.mpz_init(&l);
    var r: c.mpz_t = undefined;
    c.mpz_init(&r);

    const m = @divFloor((a + b), 2);
    bigIntMulRange(&l, a, m);
    bigIntMulRange(&r, m + 1, b);

    c.mpz_mul(out, &l, &r);

    c.mpz_clear(&l);
    c.mpz_clear(&r);
}
