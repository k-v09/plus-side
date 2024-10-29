const std = @import("std");
const expect = std.testing.expect;
const ginp = @import("./ginp.zig");
const getInp = ginp.getInput;

const collCall = struct {
    steps: u16 = 0,
    maxVal: u64 = 0,
    converges: bool = true,
};

fn converges(n: u64) u64 {
    var counter: u64 = 0;
    var q = n;
    while (q != 1) {
        if (q % 2 == 0) {
            q /= 2;
        } else {
            q *= 3;
            q += 1;
        }
        counter += 1;
    }
    return counter;
}

fn typeConversion(s: []const u8) u64 {
    try {
        const q = s.len - 1;
        var sum: u64 = 0;
        for (s, 0..) |char, index| {
            if (char <= 48 or char >= 57) {
                return 0;
            }
            // ASCII conversion here cause I forgot about that ugh
            // I'll do it later cause that's just annoying
            // sum += (q - index) * 10 * char;
        }
        return sum;
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const stdout = std.io.getStdOut().writer();
    var longest = [2]u64{ 0, 0 };
    var avg: f128 = 0.0;
    var cnum: u64 = 1;
    const inpNum = try getInp(allocator, "Up to what number: ");
    try stdout.print("Input number type: {}\n", .{@TypeOf(inpNum)});
    try stdout.print("Here's that thang: {any}\n", .{inpNum});
    defer allocator.free(inpNum);
    while (cnum <= 10000) {
        const c = converges(cnum);
        //try stdout.print("{} converges: {}\n", .{ cnum, c });
        if (c != 255) {
            const floatcnum: f128 = @as(f128, @floatFromInt(cnum));
            avg = (avg * (floatcnum - 1.0) + @as(f128, @floatFromInt(c))) / floatcnum;
            if (c > longest[0]) {
                longest[0] = c;
                longest[1] = cnum;
            }
        } else {
            try stdout.print("OH SHIT BABAYYYYYYY\n", .{});
        }
        cnum += 1;
    }
    try stdout.print("Longest string: {} at value {}\nAverage: {}\n", .{ longest[0], longest[1], avg });
}

test "Type Conversions" {
    const correct = [5]u8{ 2, 5, 4, 1, 1 };
    const incorrect = [5]u8{ 6, 4, "e", 5, "f" }; // Needs ASCII characters not this garbage
    const ctest: u64 = typeConversion(correct);
    try expect(ctest == 25411);
    const itest = typeConversion(incorrect);
    try expect(itest == 0);
}
