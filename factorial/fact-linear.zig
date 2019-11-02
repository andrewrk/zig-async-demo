const std = @import("std");
const Allocator = std.mem.Allocator;
const BigInt = std.math.big.Int;

pub fn main() !void {
    try fact(3000000);
}

fn fact(n: u64) !void {
    const allocator = std.heap.direct_allocator;
    var x = try BigInt.init(allocator);
    defer x.deinit();
    try bigIntMultRange(allocator, &x, 1, n);
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
