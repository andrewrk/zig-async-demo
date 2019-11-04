const std = @import("std");
const BigInt = std.math.big.Int;
const allocator = std.heap.c_allocator;

pub const io_mode = .evented;

pub fn main() !void {
    try fact(3000000);
}

fn fact(n: u64) !void {
    var x = try BigInt.init(allocator);
    defer x.deinit();
    return bigIntMultRange(&x, 1, n);
}

fn bigIntMultRange(out: *BigInt, a: u64, b: u64) anyerror!void {
    if (a == b) {
        try out.set(a);
        return;
    }

    std.event.Loop.startCpuBoundOperation();

    var l = try BigInt.init(allocator);
    defer l.deinit();
    var r = try BigInt.init(allocator);
    defer r.deinit();

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

    try BigInt.mul(out, l, r);
}
