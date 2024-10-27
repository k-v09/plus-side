const std = @import("std");
const expect = std.testing.expect;

fn isEven(n: u8) bool {
    return n % 2 == 0;
}

test "Even Checker" {
    try expect(isEven(2));
    try expect(!isEven(3));
}
