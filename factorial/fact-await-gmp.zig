const std = @import("std");
const BigInt = std.math.big.Int;
const allocator = std.heap.c_allocator;
const c = @cImport({
    @cInclude("gmp.h");
});

pub const io_mode = .evented;

pub fn main() !void {
    try fact(3000000);
}

fn fact(n: u64) !void {
    var x: c.mpz_t = undefined;
    c.mpz_init(&x);
    defer c.mpz_clear(&x);
    try bigIntMultRange(&x, 1, n);
}

fn bigIntMultRange(out: *c.mpz_t, a: u64, b: u64) anyerror!void {
    if (a == b) {
        c.mpz_init_set_ui(out, a);
        return;
    }

    std.event.Loop.startCpuBoundOperation();

    var l: c.mpz_t = undefined;
    c.mpz_init(&l);
    defer c.mpz_clear(&l);

    var r: c.mpz_t = undefined;
    c.mpz_init(&r);
    defer c.mpz_clear(&r);

    const m = @divFloor((a + b), 2);

    const frame_l = try allocator.create(@Frame(bigIntMultRange));
    defer allocator.destroy(frame_l);
    const frame_r = try allocator.create(@Frame(bigIntMultRange));
    defer allocator.destroy(frame_r);

    frame_l.* = async bigIntMultRange(&l, a, m);
    frame_r.* = async bigIntMultRange(&r, m + 1, b);

    const res_l = await frame_l;
    const res_r = await frame_r;

    try res_l;
    try res_r;

    c.mpz_mul(out, &l, &r);
}
