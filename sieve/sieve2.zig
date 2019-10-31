const std = @import("std");

fn fillSieve(primes_buffer: []u32, start_index: usize) void {
    var fill_i: usize = start_index;
    if (fill_i < 2) {
        primes_buffer[0] = 2;
        primes_buffer[1] = 3;
        fill_i = 2;
    }
    while (fill_i < primes_buffer.len) : (fill_i += 1) {
        var n = primes_buffer[fill_i - 1];
        const next_prime = while (true) {
            n += 2;
            for (primes_buffer[0..fill_i]) |prev_prime| {
                if (n % prev_prime == 0) break;
            } else break n;
        } else unreachable;
        primes_buffer[fill_i] = next_prime;
    }
}

pub fn main() anyerror!void {
    const stdout_file = try std.io.getStdOut();
    const stdout_unbuffered = &stdout_file.outStream().stream;
    var buffered_stream = std.io.BufferedOutStream(std.fs.File.WriteError).init(stdout_unbuffered);
    const stdout = &buffered_stream.stream;

    var primes_buffer: [1000]u32 = undefined;
    fillSieve(&primes_buffer, 0);

    for (primes_buffer) |prime| {
        try stdout.print("{}\n", prime);
    }

    try buffered_stream.flush();
}
