const std = @import("std");
const expect = std.testing.expect;

const collCall = struct {
    steps: u16 = 0,
    maxVal: u64 = 0,
    converges: bool = true,
};

fn isEven(n: u8) bool {
    return n % 2 == 0;
}

fn converges(n: u8) bool {
    var counter: u8 = 0;
    var q = n;
    while (q != 1) {
        if (isEven(q)) {
            q /= 2;
        } else {
            q *= 3;
            q += 1;
        }
        counter += 1;
        if (counter >= 50) return false;
    }
    return true;
}

test "Even Checker" {
    try expect(isEven(2));
    try expect(!isEven(3));
}

test "Collatz Convergence" {
    try expect(converges(5));
    try expect(converges(6));
}
