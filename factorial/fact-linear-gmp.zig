const c = @cImport({
    @cInclude("gmp.h");
});

pub fn main() void {
    fact(3000000);
}

fn fact(n: u64) void {
    var x: c.mpz_t = undefined;
    c.mpz_init(&x);
    defer c.mpz_clear(&x);

    bigIntMultRange(&x, 1, n);
}

fn bigIntMultRange(out: *c.mpz_t, a: u64, b: u64) void {
    if (a == b) {
        c.mpz_init_set_ui(out, a);
        return;
    }

    var l: c.mpz_t = undefined;
    c.mpz_init(&l);
    defer c.mpz_clear(&l);

    var r: c.mpz_t = undefined;
    c.mpz_init(&r);
    defer c.mpz_clear(&r);

    const m = @divFloor((a + b), 2);
    bigIntMultRange(&l, a, m);
    bigIntMultRange(&r, m + 1, b);

    c.mpz_mul(out, &l, &r);
}
