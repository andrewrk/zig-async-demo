// A concurrent prime sieve
// Note: this would not be the recommended way to implement a
// concurrent prime sieve in Zig; this implementation is intended
// to serve as a direct port of the reference Go code.

const std = @import("std");
const Channel = std.event.Channel;

pub const io_mode = .evented;

// Send the sequence 2, 3, 4, ... to channel 'ch'.
fn generate(ch: *Channel(u32)) void {
    var i: u32 = 2;
    while (true) : (i += 1) {
        ch.put(i);
    }
}

// Copy the values from channel 'in' to channel 'out',
// removing those divisible by 'prime'.
fn filter(in: *Channel(u32), out: *Channel(u32), prime: u32) void {
    while (true) {
        const i = in.get();
        if (i % prime != 0) {
            out.put(i);
        }
    }
}

// The prime sieve: Daisy-chain Filter processes.
pub fn main() anyerror!void {
    // This techinque requires O(N) memory. It's not obvious from the Go
    // code, but Zig has no hidden allocations.
    // An arena allocator lets us free all the memory at once.
    // In this case we let the operating system do the freeing, since
    // that is most efficient.
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = &arena.allocator;

    // Create a new channel.
    var ch = try allocator.create(Channel(u32));
    ch.init(&[0]u32{}); // Unbuffered channel.

    // Start the generate async function.
    // In this case we let it run forever, not bothering to `await`.
    _ = async generate(ch);

    var i: usize = 0;
    while (i < 10) : (i += 1) {
        const prime = ch.get();
        std.debug.warn("{}\n", .{ prime });
        const ch1 = try allocator.create(Channel(u32));
        ch1.init(&[0]u32{});
        (try allocator.create(@Frame(filter))).* = async filter(ch, ch1, prime);
        ch = ch1;
    }
}
