const std = @import("std");
const BigInt = std.math.big.Int;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    try fact(std.heap.c_allocator, 3000000);
}

fn fact(allocator: *Allocator, n: u64) !void {
    var x = try BigInt.init(allocator);
    defer x.deinit();
    return bigIntMultRange(allocator, &x, 1, n);
}

fn bigIntMultRange(allocator: *Allocator, out: *BigInt, a: u64, b: u64) anyerror!void {
    if (a == b) {
        try out.set(a);
        return;
    }

    var l = try BigInt.init(allocator);
    defer l.deinit();
    var r = try BigInt.init(allocator);
    defer r.deinit();

    const m = @divFloor((a + b), 2);
    try bigIntMultRange(allocator, &l, a, m);
    try bigIntMultRange(allocator, &r, m + 1, b);

    try BigInt.mul(out, l, r);
}
