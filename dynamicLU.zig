const std = @import("std");

pub fn DynamicTable(comptime T: type) type {
    return struct {
        data: std.ArrayList(T),

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator) Self {
            return Self{
                .data = std.ArrayList(T).init(allocator),
            };
        }
        pub fn deinit(self: *Self) void {
            self.data.deinit();
        }

        pub fn set(self: *Self, index: usize, value: T) !void {
            if (index >= self.data.items.len) {
                try self.data.resize(index + 1);
            }
            self.data.items[index] = value;
        }
        pub fn get(self: Self, index: usize) ?T {
            if (index >= self.data.items.len) return null;
            return self.data.items[index];
        }
        pub fn append(self: *Self, value: T) !void {
            try self.data.append(value);
        }
        pub fn pop(self: *Self) ?T {
            return if (self.data.items.len == 0) null else self.data.pop();
        }
        pub fn insert(self: *Self, index: usize, value: T) !void {
            try self.data.insert(index, value);
        }
        pub fn remove(self: *Self, index: usize) ?T {
            return if (index >= self.data.items.len)
                null
            else
                self.data.orderedRemove(index);
        }
        pub fn getSize(self: Self) usize {
            return self.data.items.len;
        }
        pub fn clear(self: *Self) void {
            self.data.clearRetainingCapacity();
        }
        pub fn slice(self: Self) []T {
            return self.data.items;
        }
        pub fn contains(self: Self, value: T) bool {
            for (self.data.items) |item| {
                if (item == value) return true;
            }
            return false;
        }
    };
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var table = DynamicTable(u32).init(allocator);
    defer table.deinit();

    try table.append(10);
    try table.append(20);
    try table.append(30);

    try stdout.print("Initial table: ", .{});
    for (table.slice()) |value| {
        try stdout.print("{} ", .{value});
    }
    try stdout.print("\n", .{});
    try stdout.print("Table contains 15: {}\n", .{table.contains(15)});

    try table.insert(1, 15);
    try stdout.print("After insert(1, 15): ", .{});
    for (table.slice()) |value| {
        try stdout.print("{} ", .{value});
    }
    try stdout.print("\n", .{});
    try stdout.print("Table contains 15: {}\n", .{table.contains(15)});

    _ = table.remove(2);
    try stdout.print("After remove(2): ", .{});
    for (table.slice()) |value| {
        try stdout.print("{} ", .{value});
    }
    try stdout.print("\n", .{});

    if (table.pop()) |value| {
        try stdout.print("Popped: {}\n", .{value});
    }

    try stdout.print("Final table: ", .{});
    for (table.slice()) |value| {
        try stdout.print("{} ", .{value});
    }
    try stdout.print("\n", .{});
    table.clear();
    try stdout.print("Size after clear: {}\n", .{table.getSize()});
}
