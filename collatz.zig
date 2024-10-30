const std = @import("std");
const ginp = @import("./ginp.zig");
const f = @import("./dynamicLU.zig");
const expect = std.testing.expect;
const getInp = ginp.getInput;
const math = std.math;
const tab = f.DynamicTable;

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
            if (char < 48 or char > 57) {
                return 0;
            }
            sum += (char - 48) * math.pow(u64, 10, (q - index));
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
    var avg: f64 = 0.0;
    var cnum: u64 = 1;
    const inpNum = try getInp(allocator, "Up to what number: ");
    defer allocator.free(inpNum);
    while (cnum <= typeConversion(inpNum)) {
        const c = converges(cnum);
        //try stdout.print("{} converges: {}\n", .{ cnum, c });
        if (c != 18446744073709551615) {
            const floatcnum: f64 = @as(f64, @floatFromInt(cnum));
            avg = (avg * (floatcnum - 1.0) + @as(f64, @floatFromInt(c))) / floatcnum;
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
    const correct = [5]u8{ 50, 49, 51, 51, 54 };
    const incorrect = [5]u8{ 48, 7, 55, 3, 90 };
    const ctest: u64 = typeConversion(&correct);
    try expect(ctest == 21336);
    const itest = typeConversion(&incorrect);
    try expect(itest == 0);
}

test "Pleasepleaseplease" {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    var table = tab(u64).init(allocator);
    defer table.deinit();
    try stdout.print("Table initialized successfully!\n", .{});
}
