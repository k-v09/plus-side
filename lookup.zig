const std = @import("std");

fn createSquaresTable() type {
    return struct {
        const squares = blk: {
            @setEvalBranchQuota(1000);
            var table: [16]u32 = undefined;
            for (0..16) |i| {
                table[i] = i * i;
            }
            break :blk table;
        };
        pub fn lookup(index: usize) ?u32 {
            if (index >= squares.len) return null;
            return squares[index];
        }
    };
}

const SquaresTable = createSquaresTable();
pub fn main() void {
    const stdout = std.io.getStdOut().writer();
    const square5 = SquaresTable.lookup(5) orelse unreachable;
    stdout.print("Square of 5: {}\n", .{square5}) catch unreachable;
    if (SquaresTable.lookup(20)) |value| {
        stdout.print("Square of 20: {}\n", .{value}) catch unreachable;
    } else {
        stdout.print("Index 20 is out of bounds\n", .{}) catch unreachable;
    }
}
