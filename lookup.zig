const std = @import("std");

// Mutable lookup table implementation
pub fn LookupTable(comptime T: type, comptime size: usize) type {
    return struct {
        data: [size]T,

        const Self = @This();

        // Initialize the table with a default value
        pub fn init(default_value: T) Self {
            var table = Self{ .data = undefined };
            @memset(&table.data, default_value);
            return table;
        }

        // Set a value in the table
        pub fn set(self: *Self, index: usize, value: T) !void {
            if (index >= size) return error.IndexOutOfBounds;
            self.data[index] = value;
        }

        // Get a value from the table
        pub fn get(self: Self, index: usize) ?T {
            if (index >= size) return null;
            return self.data[index];
        }

        // Get the size of the table
        pub fn getSize() usize {
            return size;
        }
    };
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var table = LookupTable(u32, 16).init(0);
    try table.set(0, 42);
    try table.set(1, 123);
    try table.set(5, 999);
    try stdout.print("Value at index 0: {?}\n", .{table.get(0)});
    try stdout.print("Value at index 1: {?}\n", .{table.get(1)});
    try stdout.print("Value at index 5: {?}\n", .{table.get(5)});

    if (table.set(20, 456)) {
        try stdout.print("Set succeeded\n", .{});
    } else |err| {
        try stdout.print("Set failed: {}\n", .{err});
    }
    try stdout.print("Value at index 20: {?}\n", .{table.get(20)});

    var string_table = LookupTable([]const u8, 4).init("");
    try string_table.set(0, "Hello");
    try string_table.set(1, "World");

    try stdout.print("String at index 0: {?s}\n", .{string_table.get(0)});
    try stdout.print("String at index 1: {?s}\n", .{string_table.get(1)});
}
